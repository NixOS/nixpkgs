{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "boost-1.50.0-headers";

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_50_0.tar.bz2";
    sha256 = "0ac5b82g6b5pdhzypgddql0i3i9vvrwf9iqp3lyp19hzr2wf5b69";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/include
    tar xvf $src -C $out/include --strip-components=1 boost_1_50_0/boost
  '';

  meta = {
    homepage = "http://boost.org/";
    description = "Boost C++ Library Collection";
    license = "boost-license";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.viric stdenv.lib.maintainers.simons ];
  };
}
