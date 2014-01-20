{stdenv, fetchurl, llvm, gmp, mpfr, mpc, ncurses, zlib}:

stdenv.mkDerivation rec {
  version = "3.4";
  name = "dragonegg-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/${name}.src.tar.gz";
    sha256 = "1733czbvby1ww3xkwcwmm0km0bpwhfyxvf56wb0zv5gksp3kbgrl";
  };

  # The gcc the plugin will be built for (the same used building dragonegg)
  GCC = "gcc";

  buildInputs = [ llvm gmp mpfr mpc ncurses zlib ];

  installPhase = ''
    mkdir -p $out/lib $out/share/doc/${name}
    cp -d dragonegg.so $out/lib
    cp README COPYING $out/share/doc/${name}
  '';

  meta = {
    homepage = http://dragonegg.llvm.org/;
    description = "gcc plugin that replaces gcc's optimizers and code generators by those in LLVM";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
