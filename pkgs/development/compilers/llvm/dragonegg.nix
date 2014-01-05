{stdenv, fetchurl, llvm, gmp, mpfr, mpc}:

stdenv.mkDerivation rec {
  version = "3.3";
  name = "dragonegg-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/${name}.src.tar.gz";
    sha256 = "1kfryjaz5hxh3q6m50qjrwnyjb3smg2zyh025lhz9km3x4kshlri";
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
