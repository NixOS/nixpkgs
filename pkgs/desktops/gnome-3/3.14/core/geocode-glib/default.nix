{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json_glib }:


stdenv.mkDerivation rec {
  name = "geocode-glib-${gnome3.version}.0";


  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${gnome3.version}/${name}.tar.xz";
    sha256 = "a19b21a92b8cbfa29a5ae6616c2fdca8567e97480f7bb5c955905f6ae1c72010";
  };

  buildInputs = with gnome3;
    [ intltool pkgconfig glib libsoup json_glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
	maintainers = [ maintainers.lethalman ];
  };

}
