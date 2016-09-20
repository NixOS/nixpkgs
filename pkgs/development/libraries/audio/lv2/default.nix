{ stdenv, fetchurl, gtk2, libsndfile, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "lv2-${version}";
  version = "1.12.0";

  src = fetchurl {
    url = "http://lv2plug.in/spec/${name}.tar.bz2";
    sha256 = "1saq0vwqy5zjdkgc5ahs8kcabxfmff2mmg68fiqrkv8hiw9m6jks";
  };

  buildInputs = [ gtk2 libsndfile pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    homepage = http://lv2plug.in;
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
