{ stdenv, fetchurl, pkgconfig, exiv2, glib, libtool, m4, gnome3 }:

let
  majorVersion = "0.10";
in
stdenv.mkDerivation rec {
  name = "gexiv2-${version}";
  version = "${majorVersion}.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gexiv2/${majorVersion}/${name}.tar.xz";
    sha256 = "390cfb966197fa9f3f32200bc578d7c7f3560358c235e6419657206a362d3988";
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
