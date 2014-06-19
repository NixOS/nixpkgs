{ stdenv, fetchurl, patchelf, perl, ncurses, expat, python, zlib
, xlibs, gtk2, glib, fontconfig, freetype, unixODBC, alsaLib
} :

stdenv.mkDerivation rec {
  name = "cudatoolkit-6.0.37";

  dontPatchELF = true;
  dontStrip = true;

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://developer.download.nvidia.com/compute/cuda/6_0/rel/installers/cuda_6.0.37_linux_64.run;
        sha256 = "991e436c7a6c94ec67cf44204d136adfef87baa3ded270544fa211179779bc40";
      }
    else throw "cudatoolkit does not support platform ${stdenv.system}";

  outputs = [ "out" "sdk" ];

  buildInputs = [ perl ];

  runtimeDependencies = [
    ncurses expat python zlib
    xlibs.libX11 xlibs.libXext xlibs.libXrender xlibs.libXt xlibs.libXtst xlibs.libXi xlibs.libXext
    gtk2 glib fontconfig freetype unixODBC alsaLib
  ];

  rpath = "${stdenv.lib.makeLibraryPath runtimeDependencies}:${stdenv.gcc.gcc}/lib64";

  unpackPhase = ''
    sh $src --keep --noexec
    cd pkg/run_files
    sh cuda-linux64-rel-6.0.37-18176142.run --keep --noexec
    sh cuda-samples-linux-6.0.37-18176142.run --keep --noexec
    cd pkg
  '';

  buildPhase = ''
    find . -type f -executable -exec patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      '{}' \; || true
    find . -type f -exec patchelf \
      --set-rpath $rpath:$out/jre/lib/amd64/jli:$out/lib:$out/lib64:$out/nvvm/lib:$out/nvvm/lib64:$(cat $NIX_GCC/nix-support/orig-gcc)/lib \
      --force-rpath \
      '{}' \; || true
  '';

  installPhase = ''
    mkdir $out $sdk
    perl ./install-linux.pl --prefix="$out"
    rm $out/tools/CUDA_Occupancy_Calculator.xls
    perl ./install-sdk-linux.pl --prefix="$sdk" --cudaprefix="$out"
  '';

  meta = {
    license = [ "nonfree" ];
  };
}

