{stdenv, fetchurl, llvm, gmp, mpfr, mpc}:

stdenv.mkDerivation rec {
  name = "dragonegg-3.0";

  src = fetchurl {
    url = "http://llvm.org/releases/3.0/${name}.tar.gz";
    sha256 = "09v8bxx676iz93qk39dc2fk52iqhqy9pnphvinmm9ch1x791zpvj";
  };

  # The gcc the plugin will be built for (the same used building dragonegg)
  GCC = "gcc";

  buildInputs = [ llvm gmp mpfr mpc ];

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
