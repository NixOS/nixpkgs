{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "boost-headers-1.53.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_53_0.tar.bz2";
    sha256 = "15livg6y1l3gdsg6ybvp3y4gp0w3xh1rdcq5bjf0qaw804dh92pq";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xf $src -C $out/include --strip-components=1 boost_1_53_0/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}
