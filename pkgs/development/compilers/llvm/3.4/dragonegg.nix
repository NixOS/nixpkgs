{stdenv, fetch, llvm, gmp, mpfr, mpc, ncurses, zlib, version}:

stdenv.mkDerivation rec {
  name = "dragonegg-${version}";

  src = fetch "dragonegg" "1733czbvby1ww3xkwcwmm0km0bpwhfyxvf56wb0zv5gksp3kbgrl";

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
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; linux;
  };
}
