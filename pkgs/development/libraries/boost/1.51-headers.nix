{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "boost-headers-1.51.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_51_0.tar.bz2";
    sha256 = "fb2d2335a29ee7fe040a197292bfce982af84a645c81688a915c84c925b69696";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xf $src -C $out/include --strip-components=1 ./boost_1_51_0/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}
