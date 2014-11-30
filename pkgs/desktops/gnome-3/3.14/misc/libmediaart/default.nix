{ stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf }:

let
  majorVersion = "0.7";
in
stdenv.mkDerivation rec {
  name = "libmediaart-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libmediaart/${majorVersion}/${name}.tar.xz";
    sha256 = "3a9dffcad862aed7c0921579b93080d694b8a66f3676bfee8037867f653a1cd3";
  };

  buildInputs = [ pkgconfig glib gdk_pixbuf ];

  meta = with stdenv.lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
