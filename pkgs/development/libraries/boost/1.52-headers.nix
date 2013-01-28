{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "boost-headers-1.52.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_52_0.tar.bz2";
    sha256 = "14mc7gsnnahdjaxbbslzk79rc0d12h1i681cd3srdwr3fzynlar2";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xf $src -C $out/include --strip-components=1 boost_1_52_0/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}
