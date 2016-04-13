{ lib, stdenv, fetchurl, patchelf, perl, ncurses, expat, python26, python27, zlib
, xorg, gtk2, glib, fontconfig, freetype, unixODBC, alsaLib, glibc
}:

let

  common =
    { version, url, sha256
    , python ? python27
    }:

    stdenv.mkDerivation rec {
      name = "cudatoolkit-${version}";

      dontPatchELF = true;
      dontStrip = true;

      src =
        if stdenv.system == "x86_64-linux" then
          fetchurl {
            inherit url sha256;
          }
        else throw "cudatoolkit does not support platform ${stdenv.system}";

      outputs = [ "out" "sdk" ];

      buildInputs = [ perl ];

      runtimeDependencies = [
        ncurses expat python zlib glibc
        xorg.libX11 xorg.libXext xorg.libXrender xorg.libXt xorg.libXtst xorg.libXi xorg.libXext
        gtk2 glib fontconfig freetype unixODBC alsaLib
      ];

      rpath = "${stdenv.lib.makeLibraryPath runtimeDependencies}:${stdenv.cc.cc}/lib64";

      unpackPhase = ''
        sh $src --keep --noexec
        cd pkg/run_files
        sh cuda-linux64-rel-${version}-*.run --keep --noexec
        sh cuda-samples-linux-${version}-*.run --keep --noexec
        cd pkg
      '';

      buildPhase = ''
        find . -type f -executable -exec patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          '{}' \; || true
        find . -type f -exec patchelf \
          --set-rpath $rpath:$out/jre/lib/amd64/jli:$out/lib:$out/lib64:$out/nvvm/lib:$out/nvvm/lib64:$(cat $NIX_CC/nix-support/orig-cc)/lib \
          --force-rpath \
          '{}' \; || true
      '';

      installPhase = ''
        mkdir $out $sdk
        perl ./install-linux.pl --prefix="$out"
        rm $out/tools/CUDA_Occupancy_Calculator.xls
        perl ./install-sdk-linux.pl --prefix="$sdk" --cudaprefix="$out"

        # let's remove the 32-bit libraries, they confuse the lib64->lib mover
        rm -rf $out/lib

        # Fixup path to samples (needed for cuda 6.5 or else nsight will not find them)
        if [ -d "$out"/cuda-samples ]; then
            mv "$out"/cuda-samples "$out"/samples
        fi

        # Change the #error on GCC > 4.9 to a #warning.
        sed -i $out/include/host_config.h -e 's/#error\(.*unsupported GNU version\)/#warning\1/'
      '';

      meta = {
        license = lib.licenses.unfree;
      };
    };

in {

  cudatoolkit5 = common {
    version = "5.5.22";
    url = http://developer.download.nvidia.com/compute/cuda/5_5/rel/installers/cuda_5.5.22_linux_64.run;
    sha256 = "b997e1dbe95704e0e806e0cedc5fd370a385351fef565c7bae0917baf3a29aa4";
    python = python26;
  };

  cudatoolkit6 = common {
    version = "6.0.37";
    url = http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run;
    sha256 = "991e436c7a6c94ec67cf44204d136adfef87baa3ded270544fa211179779bc40";
  };

  cudatoolkit65 = common {
    version = "6.5.19";
    url = http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.19_linux_64.run;
    sha256 = "1x9zdmk8z784d3d35vr2ak1l4h5v4jfjhpxfi9fl9dvjkcavqyaj";
  };

  cudatoolkit7 = common {
    version = "7.0.28";
    url = http://developer.download.nvidia.com/compute/cuda/7_0/Prod/local_installers/cuda_7.0.28_linux.run;
    sha256 = "1km5hpiimx11jcazg0h3mjzk220klwahs2vfqhjavpds5ff2wafi";
  };

  cudatoolkit75 = common {
    version = "7.5.18";
    url = http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run;
    sha256 = "1v2ylzp34ijyhcxyh5p6i0cwawwbbdhni2l5l4qm21s1cx9ish88";
  };

}

