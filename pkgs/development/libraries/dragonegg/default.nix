{stdenv, fetchsvn, llvm, gmp, mpfr, mpc}:

stdenv.mkDerivation rec {
  name = "dragonegg-2.7";

  src = fetchsvn {
    url = http://llvm.org/svn/llvm-project/dragonegg/branches/release_27;
    rev = 105882;
    sha256 = "0j0mj3zm1nd8kaj3b28b3w2dlzc1xbywq4mcdxk5nq4yds6rx5np";
  };

  # The gcc the plugin will be built for (the same used building dragonegg)
  GCC = "gcc";

  buildInputs = [ llvm gmp mpfr mpc ];

  installPhase = ''
    ensureDir $out/lib $out/share/doc/${name}
    cp -d dragonegg.so $out/lib
    cp README COPYING $out/share/doc/${name}
  '';

  meta = {
    homepage = http://dragonegg.llvm.org/;
    description = "gcc plugin that replaces gcc's optimizers and code generators by those in LLVM";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
