{stdenv, fetchurl, pkgconfig, gtk, libXinerama, compat22 ? true, unicode ? false}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.6.3";

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/wxwindows/wxGTK-2.6.3.tar.bz2;
    md5 = "3cd76c3c47913e52a3175dd47239c6ec";
  };

  buildInputs = [
    pkgconfig gtk gtk.libtiff gtk.libjpeg gtk.libpng gtk.libpng.zlib
    libXinerama
  ];

  configureFlags = [
    "--enable-gtk2"
    (if compat22 then "--enable-compat22" else "--disable-compat22")
    "--disable-precomp-headers"
   (if unicode then "--enable-unicode" else "")
  ];

  inherit gtk compat22;
}
