{stdenv, fetch, fetchpatch, llvm, gmp, mpfr, libmpc, ncurses, zlib, version}:

stdenv.mkDerivation rec {
  name = "dragonegg-${version}";

  src = fetch "dragonegg" "1v1lc9h2nfk3lsk9sx1k4ckwddz813hqjmlp2bx2kwxx9hw364ar";

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
    maintainers = with stdenv.lib.maintainers; [viric shlevy];
    platforms = with stdenv.lib.platforms; linux;
  };
}
