{stdenv, fetchurl, pkgconfig, libxml2, libgsf, bzip2, glib, gtk, libcroco}:

stdenv.mkDerivation {
  name = "librsvg-2.34.2";

  src = fetchurl {
    url = mirror://gnome/sources/librsvg/2.34/librsvg-2.34.2.tar.xz;
    sha256 = "0r24xr10chmz4l3ka2zy9c2245s7svzljbw9nrda3h44bcr03rsx";
  };
  buildInputs = [ libxml2 libgsf bzip2 libcroco ];
  propagatedBuildInputs = [ glib gtk ];
  buildNativeInputs = [ pkgconfig ];

  # It tries to install the loader to $gdk_pixbuf
  configureFlags = "--disable-pixbuf-loader";
}
