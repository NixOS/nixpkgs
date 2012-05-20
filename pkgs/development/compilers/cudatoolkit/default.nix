{ stdenv, fetchurl, patchelf, perl, ncurses, expat, python, zlib
, xlibs, fontconfig, freetype, unixODBC, alsaLib
} :

stdenv.mkDerivation rec {
  name = "cudatoolkit-4.2.9";

  dontPatchELF = true;
  dontStrip = true;

  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = http://developer.download.nvidia.com/compute/cuda/4_2/rel/toolkit/cudatoolkit_4.2.9_linux_64_suse11.2.run;
        sha256 = "1inngzwq520bhpdfrh5bm4cxfyf3hxj94jialjxgviri5bj9hz60";
      }
    else throw "cudatoolkit does not support platform ${stdenv.system}";

  buildInputs = [ perl ];

  runtimeDependencies = [
    ncurses expat python zlib
    xlibs.libX11 xlibs.libXext xlibs.libXrender xlibs.libXt xlibs.libXtst xlibs.libXi xlibs.libXext
    fontconfig freetype unixODBC alsaLib
  ];

  rpath = "${stdenv.lib.makeLibraryPath runtimeDependencies}:${stdenv.gcc.gcc}/lib64";

  unpackPhase = ''
    sh $src --keep --noexec
    cd pkg
  '';

  buildPhase = ''
    find . -type f -executable -exec patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      '{}' \; || true
    find . -type f -exec patchelf \
      --set-rpath $rpath:$out/lib:$out/lib64:$(cat $NIX_GCC/nix-support/orig-gcc)/lib \
      --force-rpath \
      '{}' \; || true
  '';

  installPhase = ''
    mkdir $out
    perl ./install-linux.pl --prefix="$out"
  '';

  meta = {
    license = [ "nonfree" ];
  };
}
