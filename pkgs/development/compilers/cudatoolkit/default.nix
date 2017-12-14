{ lib, stdenv, makeWrapper, fetchurl, requireFile, patchelf, perl, ncurses, expat, python27, zlib
, gcc48, gcc49, gcc5, gcc6
, xorg, gtk2, glib, fontconfig, freetype, unixODBC, alsaLib, glibc
}:

let

  common =
    args@{ gcc, version, sha256
    , url ? ""
    , name ? ""
    , developerProgram ? false
    , python ? python27
    }:

    stdenv.mkDerivation rec {
      name = "cudatoolkit-${version}";
      inherit (args) version;

      dontPatchELF = true;
      dontStrip = true;

      src =
        if developerProgram then
          requireFile {
            message = ''
              This nix expression requires that ${args.name} is already part of the store.
              Register yourself to NVIDIA Accelerated Computing Developer Program, retrieve the CUDA toolkit
              at https://developer.nvidia.com/cuda-toolkit, and run the following command in the download directory:
              nix-prefetch-url file://${args.name}
            '';
            inherit (args) name sha256;
          }
        else
          fetchurl {
            inherit (args) url sha256;
          };

      outputs = [ "out" "lib" "doc" ];

      nativeBuildInputs = [ perl makeWrapper ];

      runtimeDependencies = [
        ncurses expat python zlib glibc
        xorg.libX11 xorg.libXext xorg.libXrender xorg.libXt xorg.libXtst xorg.libXi xorg.libXext
        gtk2 glib fontconfig freetype unixODBC alsaLib
      ];

      rpath = "${stdenv.lib.makeLibraryPath runtimeDependencies}:${stdenv.cc.cc.lib}/lib64";

      unpackPhase = ''
        sh $src --keep --noexec
        cd pkg/run_files
        sh cuda-linux*.run --keep --noexec
        sh cuda-samples*.run --keep --noexec
        cd pkg
      '';

      buildPhase = ''
        chmod -R u+w .
        while IFS= read -r -d ''$'\0' i; do
          if ! isELF "$i"; then continue; fi
          echo "patching $i..."
          if [[ ! $i =~ \.so ]]; then
            patchelf \
              --set-interpreter "''$(cat $NIX_CC/nix-support/dynamic-linker)" $i
          fi
          if [[ $i =~ libcudart ]]; then
            rpath2=
          else
            rpath2=$rpath:$lib/lib:$out/jre/lib/amd64/jli:$out/lib:$out/lib64:$out/nvvm/lib:$out/nvvm/lib64
          fi
          patchelf --set-rpath $rpath2 --force-rpath $i
        done < <(find . -type f -print0)
      '';

      installPhase = ''
        mkdir $out
        perl ./install-linux.pl --prefix="$out"

        rm $out/tools/CUDA_Occupancy_Calculator.xls # FIXME: why?

        # let's remove the 32-bit libraries, they confuse the lib64->lib mover
        rm -rf $out/lib

        # Remove some cruft.
        rm $out/bin/uninstall*

        # Fixup path to samples (needed for cuda 6.5 or else nsight will not find them)
        if [ -d "$out"/cuda-samples ]; then
            mv "$out"/cuda-samples "$out"/samples
        fi

        # Change the #error on GCC > 4.9 to a #warning.
        sed -i $out/include/host_config.h -e 's/#error\(.*unsupported GNU version\)/#warning\1/'

        # Fix builds with newer glibc version
        sed -i "1 i#define _BITS_FLOATN_H" "$out/include/host_defines.h"

        # Ensure that cmake can find CUDA.
        mkdir -p $out/nix-support
        echo "cmakeFlags+=' -DCUDA_TOOLKIT_ROOT_DIR=$out'" >> $out/nix-support/setup-hook

        # Move some libraries to the lib output so that programs that
        # depend on them don't pull in this entire monstrosity.
        mkdir -p $lib/lib
        mv -v $out/lib64/libcudart* $lib/lib/

        # Remove OpenCL libraries as they are provided by ocl-icd and driver.
        rm -f $out/lib64/libOpenCL*

        # Set compiler for NVCC.
        wrapProgram $out/bin/nvcc \
          --prefix PATH : ${gcc}/bin
      '' + lib.optionalString (lib.versionOlder version "8.0") ''
        # Hack to fix building against recent Glibc/GCC.
        echo "NIX_CFLAGS_COMPILE+=' -D_FORCE_INLINES'" >> $out/nix-support/setup-hook
      '';

      passthru = {
        cc = gcc;
        majorVersion =
          let versionParts = lib.splitString "." version;
          in "${lib.elemAt versionParts 0}.${lib.elemAt versionParts 1}";
      };

      meta = with stdenv.lib; {
        description = "A compiler for NVIDIA GPUs, math libraries, and tools";
        homepage = "https://developer.nvidia.com/cuda-toolkit";
        platforms = [ "x86_64-linux" ];
        license = licenses.unfree;
      };
    };

in {

  cudatoolkit6 = common {
    version = "6.0.37";
    url = "http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run";
    sha256 = "991e436c7a6c94ec67cf44204d136adfef87baa3ded270544fa211179779bc40";
    gcc = gcc48;
  };

  cudatoolkit65 = common {
    version = "6.5.19";
    url = "http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.19_linux_64.run";
    sha256 = "1x9zdmk8z784d3d35vr2ak1l4h5v4jfjhpxfi9fl9dvjkcavqyaj";
    gcc = gcc48;
  };

  cudatoolkit7 = common {
    version = "7.0.28";
    url = "http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run";
    sha256 = "1km5hpiimx11jcazg0h3mjzk220klwahs2vfqhjavpds5ff2wafi";
    gcc = gcc49;
  };

  cudatoolkit75 = common {
    version = "7.5.18";
    url = "http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run";
    sha256 = "1v2ylzp34ijyhcxyh5p6i0cwawwbbdhni2l5l4qm21s1cx9ish88";
    gcc = gcc49;
  };

  cudatoolkit8 = common {
    version = "8.0.61";
    url = "https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run";
    sha256 = "1i4xrsqbad283qffvysn88w2pmxzxbbby41lw0j1113z771akv4w";
    gcc = gcc5;
  };

  cudatoolkit9 = common {
    version = "9.0.176";
    url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run";
    sha256 = "0308rmmychxfa4inb1ird9bpgfppgr9yrfg1qp0val5azqik91ln";
    gcc = gcc6;
  };

}

