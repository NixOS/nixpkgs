{ stdenv, fetchurl, pkgconfig, exiv2, glib, libtool, m4, gnome3 }:

let
  majorVersion = "0.10";
in
stdenv.mkDerivation rec {
  name = "gexiv2-${version}";
  version = "${majorVersion}.4";

  src = fetchurl {
    url = "mirror://gnome/sources/gexiv2/${majorVersion}/${name}.tar.xz";
    sha256 = "190www3b61spfgwx42jw8h5hsz2996jcxky48k63468avjpk33dd";
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
    maintainers = gnome3.maintainers;
  };
}
