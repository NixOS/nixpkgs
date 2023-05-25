{
  addOpenGLRunpath,
  alsa-lib,
  autoAddOpenGLRunpathHook,
  autoPatchelfHook,
  backendStdenv, # E.g. gcc11Stdenv, set in extension.nix
  cudaFlags,
  developerProgram ? false,
  expat,
  fetchurl,
  fontconfig,
  freeglut,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gtk2,
  krb5,
  lib,
  libGLU,
  libkrb5,
  libsForQt5,
  libtiff,
  libxkbcommon,
  makeWrapper,
  name ? "",
  ncurses5,
  nss,
  numactl,
  perl,
  pulseaudio,
  python3, # FIXME: CUDAToolkit 10 may still need python27
  qt6Packages,
  rdma-core,
  requireFile,
  rsync,
  runPatches ? [],
  sha256,
  stdenv,
  ucx,
  unixODBC,
  url ? "",
  version,
  wayland,
  xorg,
  zlib,
}: let
  inherit (lib.lists) elem filter optionals;
  inherit (lib.strings) concatStringsSep optionalString versionAtLeast versionOlder;
  inherit (lib.trivial) warnIf;
  inherit (lib.versions) major majorMinor;

  # unsupportedCapabilities :: List Capability
  unsupportedCapabilities =
    filter
    (computeCapability: !elem computeCapability cudaFlags.cudaSupportedCapabilities)
    cudaFlags.cudaCapabilities;

  # broken :: Bool
  broken = let
    isBroken = unsupportedCapabilities != [];
  in
    warnIf
    isBroken
    ''
      CUDA ${version} supports the following capabilities:
        ${concatStringsSep ", " cudaFlags.cudaSupportedCapabilities}
      However, the following unsupported capabilities were requested:
        ${concatStringsSep ", " unsupportedCapabilities}
      This means that packages relying on this version of CUDA are not available.
      If possible, consider upgrading to a newer version of CUDA.
    ''
    isBroken;
in
  backendStdenv.mkDerivation {
    pname = "cudatoolkit";
    inherit version runPatches;

    dontPatchELF = true;
    dontStrip = true;

    src =
      if developerProgram
      then
        requireFile {
          inherit name sha256;
          message = ''
            This nix expression requires that ${name} is already part of the store.
            Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the CUDA toolkit
            at https://developer.nvidia.com/cuda-toolkit, and run the following command in the download directory:
            nix-prefetch-url file://\$PWD/${name}
          '';
        }
      else
        fetchurl {
          inherit url sha256;
        };

    outputs = ["out" "lib" "doc"];

    nativeBuildInputs =
      [
        addOpenGLRunpath
        autoAddOpenGLRunpathHook
        autoPatchelfHook
        makeWrapper
        perl
        rsync
      ]
      ++ optionals (versionOlder version "11") [
        libsForQt5.wrapQtAppsHook
      ]
      ++ optionals (versionAtLeast version "11.8") [
        qt6Packages.wrapQtAppsHook
      ];
    buildInputs =
      optionals (versionOlder version "11") [
        freeglut
        libGLU
        libsForQt5.qt5.qtwebengine
      ]
      ++ [
        # To get $GDK_PIXBUF_MODULE_FILE via setup-hook
        gdk-pixbuf

        # For autoPatchelf
        alsa-lib
        expat
        fontconfig
        freetype
        glib
        glibc
        gtk2
        krb5
        libkrb5
        libxkbcommon
        ncurses5
        nss
        numactl
        pulseaudio
        python3
        unixODBC
        wayland
        xorg.libX11
        xorg.libxcb
        xorg.libXdamage
        xorg.libXext
        xorg.libXext
        xorg.libXi
        xorg.libXrender
        xorg.libXt
        xorg.libXtst
        xorg.xcbutilimage
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        xorg.xcbutilwm
        zlib
      ]
      ++ optionals (versionAtLeast version "11.8") [
        (lib.getLib libtiff)
        qt6Packages.qtwayland
        rdma-core
        ucx
        xorg.libxshmfence
        xorg.libxkbfile
      ];

    # Prepended to runpaths by autoPatchelf.
    # The order inherited from older rpath preFixup code
    runtimeDependencies = [
      (placeholder "lib")
      (placeholder "out")
      "${placeholder "out"}/nvvm"
      # NOTE: use the same libstdc++ as the rest of nixpkgs, not from backendStdenv
      "${lib.getLib stdenv.cc.cc}/lib64"
      "${placeholder "out"}/jre/lib/amd64/jli"
      "${placeholder "out"}/lib64"
      "${placeholder "out"}/nvvm/lib64"
    ];

    autoPatchelfIgnoreMissingDeps = [
      # This is the hardware-dependent userspace driver that comes from
      # nvidia_x11 package. It must be deployed at runtime in
      # /run/opengl-driver/lib or pointed at by LD_LIBRARY_PATH variable, rather
      # than pinned in runpath
      "libcuda.so.1"

      # The krb5 expression ships libcom_err.so.3 but cudatoolkit asks for the
      # older
      # This dependency is asked for by target-linux-x64/CollectX/RedHat/x86_64/libssl.so.10
      # - do we even want to use nvidia-shipped libssl?
      "libcom_err.so.2"
    ];

    unpackPhase =
      ''
        sh $src --keep --noexec
      ''
      + optionalString (versionOlder version "10.1") ''
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
      '';

    installPhase =
      ''
        runHook preInstall
        mkdir $out
      ''
      + optionalString (versionOlder version "10.1") ''
        cd $(basename $src)
        export PERL5LIB=.
        perl ./install-linux.pl --prefix="$out"
        cd ..
        for patch in $runPatches; do
          cd $(basename $patch)
          perl ./install_patch.pl --silent --accept-eula --installdir="$out"
          cd ..
        done
      ''
      + optionalString (versionAtLeast version "10.1" && versionOlder version "11") ''
        cd pkg/builds/cuda-toolkit
        mv * $out/
      ''
      + optionalString (versionAtLeast version "11") ''
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
        rm $out/host-linux-x64/libstdc++.so*
      ''
      # error: auto-patchelf could not satisfy dependency libtiff.so.5 wanted by /nix/store/.......-cudatoolkit-12.0.1/host-linux-x64/Plugins/imageformats/libqtiff.so
      # we only ship libtiff.so.6, so let's use qt plugins built by Nix.
      # TODO: don't copy, come up with a symlink-based "merge"
      + optionalString (versionAtLeast version "11.8") ''
        rsync ${lib.getLib qt6Packages.qtimageformats}/lib/qt-6/plugins/ $out/host-linux-x64/Plugins/ -aP
      ''
      + ''
        rm -f $out/tools/CUDA_Occupancy_Calculator.xls # FIXME: why?
      ''
      + optionalString (versionOlder version "10.1") ''
        # let's remove the 32-bit libraries, they confuse the lib64->lib mover
        rm -rf $out/lib
      ''
      # Remove some cruft.
      + optionalString ((versionAtLeast version "7.0") && (versionOlder version "10.1")) ''
        rm $out/bin/uninstall*
      ''
      # Fixup path to samples (needed for cuda 6.5 or else nsight will not find them)
      + ''
        if [ -d "$out"/cuda-samples ]; then
          mv "$out"/cuda-samples "$out"/samples
        fi

        # Change the #error on GCC > 4.9 to a #warning.
        sed -i $out/include/host_config.h -e 's/#error\(.*unsupported GNU version\)/#warning\1/'

        # Fix builds with newer glibc version
        sed -i "1 i#define _BITS_FLOATN_H" "$out/include/host_defines.h"
      ''
      # Point NVCC at a compatible compiler
      # FIXME: redist cuda_nvcc copy-pastes this code
      # Refer to comments in the overrides for cuda_nvcc for explanation
      # CUDA_TOOLKIT_ROOT_DIR is legacy,
      # Cf. https://cmake.org/cmake/help/latest/module/FindCUDA.html#input-variables
      # NOTE: We unconditionally set -Xfatbin=-compress-all, which reduces the size of the compiled
      #   binaries. If binaries grow over 2GB, they will fail to link. This is a problem for us, as
      #   the default set of CUDA capabilities we build can regularly cause this to occur (for
      #   example, with Magma).
      + ''
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
      ''
      + optionalString (versionAtLeast version "10.1" && (versionOlder version "11")) ''
        mv $out/lib64 $out/lib
        mv $out/extras/CUPTI/lib64/libcupti* $out/lib
      ''
      # nvprof do not find any program to profile if LD_LIBRARY_PATH is not set
      + ''
        wrapProgram $out/bin/nvprof --prefix LD_LIBRARY_PATH : $out/lib
      ''
      + optionalString (versionOlder version "8.0") ''
        # Hack to fix building against recent Glibc/GCC.
        echo "NIX_CFLAGS_COMPILE+=' -D_FORCE_INLINES'" >> $out/nix-support/setup-hook
      ''
      # 11.8 includes a broken symlink, include/include, pointing to targets/x86_64-linux/include
      + lib.optionalString (lib.versions.majorMinor version == "11.8") ''
        rm $out/include/include
      ''
      + ''
        runHook postInstall
      '';

    postInstall = let
      exes =
        ["nvvp"]
        ++ optionals (versionOlder version "11") ["nsight"];
    in ''
      for b in ${concatStringsSep " " exes}; do
        wrapProgram "$out/bin/$b" --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"
      done
    '';

    # cuda-gdb doesn't run correctly when not using sandboxing, so
    # temporarily disabling the install check.  This should be set to true
    # when we figure out how to get `cuda-gdb --version` to run correctly
    # when not using sandboxing.
    doInstallCheck = false;
    postInstallCheck = ''
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
      majorMinorVersion = majorMinor version;
      majorVersion = major version;
    };

    meta = with lib; {
      inherit broken;
      description = "A compiler for NVIDIA GPUs, math libraries, and tools";
      homepage = "https://developer.nvidia.com/cuda-toolkit";
      platforms = ["x86_64-linux"];
      license = licenses.unfree;
      maintainers = teams.cuda.members;
    };
  }
