{ stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf }:

stdenv.mkDerivation rec {
  name = "libmediaart-0.4.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libmediaart/0.4/${name}.tar.xz";
    sha256 = "e8ec92a642f4df7f988364f6451adf89e1611d7379a636d8c7eff4ca21a0fd1c";
  };

  buildInputs = [ pkgconfig glib gdk_pixbuf ];

  meta = with stdenv.lib; {
    description = "Library tasked with managing, extracting and handling media art caches";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
