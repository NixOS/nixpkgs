{ lib, stdenv, fetchurl, patchelf, perl, ncurses, expat, python, zlib
, xlibs, gtk2, glib, fontconfig, freetype, unixODBC, alsaLib
}:

let version = "6.5.19"; in

stdenv.mkDerivation rec {
  name = "cudatoolkit-${version}";

  dontPatchELF = true;
  dontStrip = true;

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_${version}_linux_64.run";
        sha256 = "1x9zdmk8z784d3d35vr2ak1l4h5v4jfjhpxfi9fl9dvjkcavqyaj";
      }
    else throw "cudatoolkit does not support platform ${stdenv.system}";

  outputs = [ "out" "sdk" ];

  buildInputs = [ perl ];

  runtimeDependencies = [
    ncurses expat python zlib
    xlibs.libX11 xlibs.libXext xlibs.libXrender xlibs.libXt xlibs.libXtst xlibs.libXi xlibs.libXext
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
    mv $out/include $out/usr_include
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    license = lib.licenses.unfree;
  };
}

