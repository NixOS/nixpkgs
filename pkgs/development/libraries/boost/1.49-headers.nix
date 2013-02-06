{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "boost-headers-1.49.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_49_0.tar.bz2";
    sha256 = "0g0d33942rm073jgqqvj3znm3rk45b2y2lplfjpyg9q7amzqlx6x";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xvf $src -C $out/include --strip-components=1 boost_1_49_0/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
