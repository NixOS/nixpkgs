args@
{ version
, sha256
, url ? ""
, name ? ""
, developerProgram ? false
, runPatches ? []
, addOpenGLRunpath
, alsa-lib
, expat
, fetchurl
, fontconfig
, freetype
, gdk-pixbuf
, glib
, glibc
, gtk2
, lib
, makeWrapper
, ncurses5
, perl
, python3
, requireFile
, backendStdenv # E.g. gcc11Stdenv, set in extension.nix
, unixODBC
, xorg
, zlib
}:

backendStdenv.mkDerivation rec {
  pname = "cudatoolkit";
  inherit version runPatches;

  dontPatchELF = true;
  dontStrip = true;

  src =
    if developerProgram then
      requireFile {
        message = ''
          This nix expression requires that ${args.name} is already part of the store.
          Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the CUDA toolkit
          at https://developer.nvidia.com/cuda-toolkit, and run the following command in the download directory:
          nix-prefetch-url file://\$PWD/${args.name}
        '';
        inherit (args) name sha256;
      }
    else
      fetchurl {
        inherit (args) url sha256;
      };

  outputs = [ "out" "lib" "doc" ];

  nativeBuildInputs = [ perl makeWrapper addOpenGLRunpath ];
  buildInputs = [ gdk-pixbuf ]; # To get $GDK_PIXBUF_MODULE_FILE via setup-hook
  runtimeDependencies = [
    ncurses5 expat python3 zlib glibc
    xorg.libX11 xorg.libXext xorg.libXrender xorg.libXt xorg.libXtst xorg.libXi xorg.libXext
    gtk2 glib fontconfig freetype unixODBC alsa-lib
  ];

  unpackPhase = ''
    sh $src --keep --noexec

    ${lib.optionalString (lib.versionOlder version "10.1") ''
      cd pkg/run_files
      sh cuda-linux*.run --keep --noexec
      sh cuda-samples*.run --keep --noexec
      mv pkg ../../$(basename $src)
      cd ../..
      rm -rf pkg

      for patch in $runPatches; do
        sh $patch --keep --noexec
        mv pkg $(basename $patch)
      done
    ''}
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    ${lib.optionalString (lib.versionOlder version "10.1") ''
    cd $(basename $src)
    export PERL5LIB=.
    perl ./install-linux.pl --prefix="$out"
    cd ..
    for patch in $runPatches; do
      cd $(basename $patch)
      perl ./install_patch.pl --silent --accept-eula --installdir="$out"
      cd ..
    done
    ''}
    ${lib.optionalString (lib.versionAtLeast version "10.1" && lib.versionOlder version "11") ''
      cd pkg/builds/cuda-toolkit
      mv * $out/
    ''}
    ${lib.optionalString (lib.versionAtLeast version "11") ''
      mkdir -p $out/bin $out/lib64 $out/include $doc
      for dir in pkg/builds/* pkg/builds/cuda_nvcc/nvvm pkg/builds/cuda_cupti/extras/CUPTI; do
        if [ -d $dir/bin ]; then
          mv $dir/bin/* $out/bin
        fi
        if [ -d $dir/doc ]; then
          (cd $dir/doc && find . -type d -exec mkdir -p $doc/\{} \;)
          (cd $dir/doc && find . \( -type f -o -type l \) -exec mv \{} $doc/\{} \;)
        fi
        if [ -L $dir/include ] || [ -d $dir/include ]; then
          (cd $dir/include && find . -type d -exec mkdir -p $out/include/\{} \;)
          (cd $dir/include && find . \( -type f -o -type l \) -exec mv \{} $out/include/\{} \;)
        fi
        if [ -L $dir/lib64 ] || [ -d $dir/lib64 ]; then
          (cd $dir/lib64 && find . -type d -exec mkdir -p $out/lib64/\{} \;)
          (cd $dir/lib64 && find . \( -type f -o -type l \) -exec mv \{} $out/lib64/\{} \;)
        fi
      done
      mv pkg/builds/cuda_nvcc/nvvm $out/nvvm

      mv pkg/builds/cuda_sanitizer_api $out/cuda_sanitizer_api
      ln -s $out/cuda_sanitizer_api/compute-sanitizer/compute-sanitizer $out/bin/compute-sanitizer

      mv pkg/builds/nsight_systems/target-linux-x64 $out/target-linux-x64
      mv pkg/builds/nsight_systems/host-linux-x64 $out/host-linux-x64
    ''}

    rm -f $out/tools/CUDA_Occupancy_Calculator.xls # FIXME: why?

    ${lib.optionalString (lib.versionOlder version "10.1") ''
    # let's remove the 32-bit libraries, they confuse the lib64->lib mover
    rm -rf $out/lib
    ''}

    # Remove some cruft.
    ${lib.optionalString ((lib.versionAtLeast version "7.0") && (lib.versionOlder version "10.1"))
      "rm $out/bin/uninstall*"}

    # Fixup path to samples (needed for cuda 6.5 or else nsight will not find them)
    if [ -d "$out"/cuda-samples ]; then
        mv "$out"/cuda-samples "$out"/samples
    fi

    # Change the #error on GCC > 4.9 to a #warning.
    sed -i $out/include/host_config.h -e 's/#error\(.*unsupported GNU version\)/#warning\1/'

    # Fix builds with newer glibc version
    sed -i "1 i#define _BITS_FLOATN_H" "$out/include/host_defines.h"
  '' +
  # Point NVCC at a compatible compiler
  # FIXME: redist cuda_nvcc copy-pastes this code
  # Refer to comments in the overrides for cuda_nvcc for explanation
  # CUDA_TOOLKIT_ROOT_DIR is legacy,
  # Cf. https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
  # NOTE: We unconditionally set -Xfatbin=-compress-all, which reduces the size of the compiled
  #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
  #   the default set of CUDA capabilities we build can regularly cause this to occur (for
  #   example, with Magma).
  ''
    mkdir -p $out/nix-support
    cat <<EOF >> $out/nix-support/setup-hook
    cmakeFlags+=' -DCUDA_TOOLKIT_ROOT_DIR=$out'
    cmakeFlags+=' -DCUDA_HOST_COMPILER=${backendStdenv.cc}/bin'
    cmakeFlags+=' -DCMAKE_CUDA_HOST_COMPILER=${backendStdenv.cc}/bin'
    if [ -z "\''${CUDAHOSTCXX-}" ]; then
      export CUDAHOSTCXX=${backendStdenv.cc}/bin;
    fi
    export NVCC_PREPEND_FLAGS+=' --compiler-bindir=${backendStdenv.cc}/bin -Xfatbin=-compress-all'
    EOF

    # Move some libraries to the lib output so that programs that
    # depend on them don't pull in this entire monstrosity.
    mkdir -p $lib/lib
    mv -v $out/lib64/libcudart* $lib/lib/

    # Remove OpenCL libraries as they are provided by ocl-icd and driver.
    rm -f $out/lib64/libOpenCL*
    ${lib.optionalString (lib.versionAtLeast version "10.1" && (lib.versionOlder version "11")) ''
      mv $out/lib64 $out/lib
      mv $out/extras/CUPTI/lib64/libcupti* $out/lib
    ''}

    # nvprof do not find any program to profile if LD_LIBRARY_PATH is not set
    wrapProgram $out/bin/nvprof \
      --prefix LD_LIBRARY_PATH : $out/lib
  '' + lib.optionalString (lib.versionOlder version "8.0") ''
    # Hack to fix building against recent Glibc/GCC.
    echo "NIX_CFLAGS_COMPILE+=' -D_FORCE_INLINES'" >> $out/nix-support/setup-hook
  '' + ''
    runHook postInstall
  '';

  postInstall = ''
    for b in nvvp ${lib.optionalString (lib.versionOlder version "11") "nsight"}; do
      wrapProgram "$out/bin/$b" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
    done
  '';

  preFixup =
    let rpath = lib.concatStringsSep ":" [
      (lib.makeLibraryPath (runtimeDependencies ++ [ "$lib" "$out" "$out/nvvm" ]))

      # The path to libstdc++ and such
      #
      # `backendStdenv` is the cuda-compatible toolchain that we pick in
      # extension.nix; we hand it to NVCC to use as a back-end, and we link
      # cudatoolkit's binaries against its libstdc++
      "${backendStdenv.cc.cc.lib}/lib64"

      "$out/jre/lib/amd64/jli"
      "$out/lib64"
      "$out/nvvm/lib64"
    ];
    in
    ''
      while IFS= read -r -d $'\0' i; do
        if ! isELF "$i"; then continue; fi
        echo "patching $i..."
        if [[ ! $i =~ \.so ]]; then
          patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $i
        fi
        if [[ $i =~ libcudart ]]; then
          patchelf --remove-rpath $i
        else
          patchelf --set-rpath "${rpath}" --force-rpath $i
        fi
      done < <(find $out $lib $doc -type f -print0)
    '' + lib.optionalString (lib.versionAtLeast version "11") ''
      for file in $out/target-linux-x64/*.so; do
        echo "patching $file..."
        patchelf --set-rpath "${rpath}:\$ORIGIN" $file
      done
    '';

  # Set RPATH so that libcuda and other libraries in
  # /run/opengl-driver(-32)/lib can be found. See the explanation in
  # addOpenGLRunpath.  Don't try to figure out which libraries really need
  # it, just patch all (but not the stubs libraries). Note that
  # --force-rpath prevents changing RPATH (set above) to RUNPATH.
  postFixup = ''
    addOpenGLRunpath --force-rpath {$out,$lib}/lib/lib*.so
  '' + lib.optionalString (lib.versionAtLeast version "11") ''
    addOpenGLRunpath $out/cuda_sanitizer_api/compute-sanitizer/*
    addOpenGLRunpath $out/cuda_sanitizer_api/compute-sanitizer/x86/*
    addOpenGLRunpath $out/target-linux-x64/*
  '' +
  # Prune broken symlinks which can cause problems with consumers of this package.
  ''
    while read -r -d "" file; do
      echo "Found and removing broken symlink $file"
      rm "$file"
    done < <(find "$out" "$lib" "$doc" -xtype l -print0)
  '';

  # cuda-gdb doesn't run correctly when not using sandboxing, so
  # temporarily disabling the install check.  This should be set to true
  # when we figure out how to get `cuda-gdb --version` to run correctly
  # when not using sandboxing.
  doInstallCheck = false;
  postInstallCheck = let
  in ''
    # Smoke test binaries
    pushd $out/bin
    for f in *; do
      case $f in
        crt)                           continue;;
        nvcc.profile)                  continue;;
        nsight_ee_plugins_manage.sh)   continue;;
        uninstall_cuda_toolkit_6.5.pl) continue;;
        computeprof|nvvp|nsight)       continue;; # GUIs don't feature "--version"
        *)                             echo "Executing '$f --version':"; ./$f --version;;
      esac
    done
    popd
  '';
  passthru = {
    inherit (backendStdenv) cc;
    majorMinorVersion = lib.versions.majorMinor version;
    majorVersion = lib.versions.majorMinor version;
  };

  meta = with lib; {
    description = "A compiler for NVIDIA GPUs, math libraries, and tools";
    homepage = "https://developer.nvidia.com/cuda-toolkit";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}

