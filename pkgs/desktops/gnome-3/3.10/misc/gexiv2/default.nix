{ stdenv, fetchurl, pkgconfig, exiv2, glib, libtool, m4 }:


stdenv.mkDerivation rec {
  name = "gexiv2-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gexiv2/0.7/${name}.tar.xz";
    sha256 = "12pfc5a57dhlf0c3yg5x3jissxi7jy2b6ir6y99cn510801gwcdn";
  };
  
  preConfigure = ''
    patchShebangs .
  '';
  
  buildInputs = [ pkgconfig glib libtool m4 ];
  propagatedBuildInputs = [ exiv2 ];
  
  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/gexiv2;
    description = "GObject wrapper around the Exiv2 photo metadata library";
    platforms = platforms.linux;
  };
}