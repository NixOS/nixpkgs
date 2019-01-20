{ lib, stdenv, makeWrapper, fetchurl, requireFile, perl, ncurses, expat, python27, zlib
, gcc48, gcc49, gcc5, gcc6, gcc7
, xorg, gtk2, glib, fontconfig, freetype, unixODBC, alsaLib, glibc
}:

let

  common =
    args@{ gcc, version, sha256
    , url ? ""
    , name ? ""
    , developerProgram ? false
    , python ? python27
    , runPatches ? []
    }:

    stdenv.mkDerivation rec {
      name = "cudatoolkit-${version}";
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

      nativeBuildInputs = [ perl makeWrapper ];

      runtimeDependencies = [
        ncurses expat python zlib glibc
        xorg.libX11 xorg.libXext xorg.libXrender xorg.libXt xorg.libXtst xorg.libXi xorg.libXext
        gtk2 glib fontconfig freetype unixODBC alsaLib
      ];

      rpath = "${stdenv.lib.makeLibraryPath runtimeDependencies}:${stdenv.cc.cc.lib}/lib64";

      phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

      unpackPhase = ''
        sh $src --keep --noexec

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

      installPhase = ''
        mkdir $out
        cd $(basename $src)
        perl ./install-linux.pl --prefix="$out"
        cd ..
        for patch in $runPatches; do
          cd $(basename $patch)
          perl ./install_patch.pl --silent --accept-eula --installdir="$out"
          cd ..
        done

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

        # nvprof do not find any program to profile if LD_LIBRARY_PATH is not set
        wrapProgram $out/bin/nvprof \
          --prefix LD_LIBRARY_PATH : $out/lib
      '' + lib.optionalString (lib.versionOlder version "8.0") ''
        # Hack to fix building against recent Glibc/GCC.
        echo "NIX_CFLAGS_COMPILE+=' -D_FORCE_INLINES'" >> $out/nix-support/setup-hook
      '';

      preFixup = ''
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
        done < <(find $out $lib $doc -type f -print0)
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

in rec {
  cudatoolkit_6 = common {
    version = "6.0.37";
    url = "http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run";
    sha256 = "991e436c7a6c94ec67cf44204d136adfef87baa3ded270544fa211179779bc40";
    gcc = gcc48;
  };

  cudatoolkit_6_5 = common {
    version = "6.5.19";
    url = "http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.19_linux_64.run";
    sha256 = "1x9zdmk8z784d3d35vr2ak1l4h5v4jfjhpxfi9fl9dvjkcavqyaj";
    gcc = gcc48;
  };

  cudatoolkit_7 = common {
    version = "7.0.28";
    url = "http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run";
    sha256 = "1km5hpiimx11jcazg0h3mjzk220klwahs2vfqhjavpds5ff2wafi";
    gcc = gcc49;
  };

  cudatoolkit_7_5 = common {
    version = "7.5.18";
    url = "http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run";
    sha256 = "1v2ylzp34ijyhcxyh5p6i0cwawwbbdhni2l5l4qm21s1cx9ish88";
    gcc = gcc49;
  };

  cudatoolkit_8 = common {
    version = "8.0.61.2";
    url = "https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run";
    sha256 = "1i4xrsqbad283qffvysn88w2pmxzxbbby41lw0j1113z771akv4w";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run";
        sha256 = "1iaz5rrsnsb1p99qiqvxn6j3ksc7ry8xlr397kqcjzxqbljbqn9d";
      })
    ];
    gcc = gcc5;
  };

  cudatoolkit_9_0 = common {
    version = "9.0.176.1";
    url = "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run";
    sha256 = "0308rmmychxfa4inb1ird9bpgfppgr9yrfg1qp0val5azqik91ln";
    gcc = gcc6;
  };

  cudatoolkit_9_1 = common {
    version = "9.1.85.3";
    url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux";
    sha256 = "0lz9bwhck1ax4xf1fyb5nicb7l1kssslj518z64iirpy2qmwg5l4";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/patches/1/cuda_9.1.85.1_linux";
        sha256 = "1f53ij5nb7g0vb5pcpaqvkaj1x4mfq3l0mhkfnqbk8sfrvby775g";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/patches/2/cuda_9.1.85.2_linux";
        sha256 = "16g0w09h3bqmas4hy1m0y6j5ffyharslw52fn25gql57bfihg7ym";
      })
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.1/Prod/patches/3/cuda_9.1.85.3_linux";
        sha256 = "12mcv6f8z33z8y41ja8bv5p5iqhv2vx91mv3b5z6fcj7iqv98422";
      })
    ];
    gcc = gcc6;
  };

  cudatoolkit_9_2 = common {
    version = "9.2.148.1";
    url = "https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux";
    sha256 = "04c6v9b50l4awsf9w9zj5vnxvmc0hk0ypcfjksbh4vnzrz14wigm";
    runPatches = [
      (fetchurl {
        url = "https://developer.nvidia.com/compute/cuda/9.2/Prod2/patches/1/cuda_9.2.148.1_linux";
        sha256 = "1kx6l4yzsamk6q1f4vllcpywhbfr2j5wfl4h5zx8v6dgfpsjm2lw";
      })
    ];
    gcc = gcc7;
  };

  cudatoolkit_9 = cudatoolkit_9_2;

  cudatoolkit_10_0 = common {
    version = "10.0.130";
    url = "https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux";
    sha256 = "16p3bv1lwmyqpxil8r951h385sy9asc578afrc7lssa68c71ydcj";

    gcc = gcc7;
  };

  cudatoolkit_10 = cudatoolkit_10_0;
}
