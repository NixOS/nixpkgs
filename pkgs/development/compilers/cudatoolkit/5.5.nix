{ stdenv, fetchurl, patchelf, perl, ncurses, expat, python, zlib
, xlibs, gtk2, glib, fontconfig, freetype, unixODBC, alsaLib
} :

stdenv.mkDerivation rec {
  name = "cudatoolkit-5.5.22";

  dontPatchELF = true;
  dontStrip = true;

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://developer.download.nvidia.com/compute/cuda/5_5/rel/installers/cuda_5.5.22_linux_64.run;
        sha256 = "b997e1dbe95704e0e806e0cedc5fd370a385351fef565c7bae0917baf3a29aa4";
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
    sh cuda-linux64-rel-5.5.22-16488124.run --keep --noexec
    sh cuda-samples-linux-5.5.22-16488124.run --keep --noexec
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
