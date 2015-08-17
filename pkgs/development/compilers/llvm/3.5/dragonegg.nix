{stdenv, fetch, fetchpatch, llvm, gmp, mpfr, libmpc, ncurses, zlib, version}:

stdenv.mkDerivation rec {
  name = "dragonegg-${version}";

  src = fetch "dragonegg" "1va4wv2b1dj0dpzsksnpnd0jic52q7pqj79w3m9jwdb58h7104dw";

  # The gcc the plugin will be built for (the same used building dragonegg)
  GCC = "gcc";

  buildInputs = [ llvm gmp mpfr libmpc ncurses zlib ];

  installPhase = ''
    mkdir -p $out/lib $out/share/doc/${name}
    cp -d dragonegg.so $out/lib
    cp README COPYING $out/share/doc/${name}
  '';

  meta = {
    homepage = http://dragonegg.llvm.org/;
    description = "gcc plugin that replaces gcc's optimizers and code generators by those in LLVM";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
