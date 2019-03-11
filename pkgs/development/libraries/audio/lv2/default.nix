{ stdenv, fetchurl, gtk2, libsndfile, pkgconfig, python, wafHook }:

stdenv.mkDerivation rec {
  name = "lv2-${version}";
  version = "1.14.0";

  src = fetchurl {
    url = "http://lv2plug.in/spec/${name}.tar.bz2";
    sha256 = "0chxwys3vnn3nxc9x2vchm74s9sx0vfra6y893byy12ci61jc1dq";
  };

  nativeBuildInputs = [ pkgconfig wafHook ];
  buildInputs = [ gtk2 libsndfile python ];

  meta = with stdenv.lib; {
    homepage = http://lv2plug.in;
    description = "A plugin standard for audio systems";
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
