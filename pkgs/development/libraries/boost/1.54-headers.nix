{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "boost-headers-1.54.0";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_54_0.tar.bz2";
    sha256 = "07df925k56pbz3gvhxpx54aij34qd40a7sxw4im11brnwdyr4zh4";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xf $src -C $out/include --strip-components=1 boost_1_54_0/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}
