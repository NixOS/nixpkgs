{ stdenv, fetchurl, pkgconfig, exiv2, glib, libtool, m4 }:

let
  majorVersion = "0.10";
in
stdenv.mkDerivation rec {
  name = "gexiv2-${version}";
  version = "${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gexiv2/${majorVersion}/${name}.tar.xz";
    sha256 = "2fd21f0ed5125e51d02226e7f41be751cfa8ae411a8ed1a651e16b06d79047b2";
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
    maintainers = [ maintainers.lethalman ];
  };
}