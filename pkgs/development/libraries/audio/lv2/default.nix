{ stdenv, fetchurl, gtk2, libsndfile, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lv2-${version}";
  version = "1.14.0";

  src = fetchurl {
    url = "http://lv2plug.in/spec/${name}.tar.bz2";
    sha256 = "0chxwys3vnn3nxc9x2vchm74s9sx0vfra6y893byy12ci61jc1dq";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 libsndfile python ];

  configurePhase = "${python.interpreter} waf configure --prefix=$out";

  buildPhase = "${python.interpreter} waf";

  installPhase = "${python.interpreter} waf install";

  meta = with stdenv.lib; {
    homepage = http://lv2plug.in;
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
