{stdenv, fetchurl, pkgconfig, gtk, compat22 ? true}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.4.2";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/wxwindows/wxGTK-2.4.2.tar.bz2;
    md5 = "cdadfe82fc93f8a65a2ae18a95b0b0e3";
  };

  buildInputs = [pkgconfig gtk gtk.libtiff gtk.libjpeg gtk.libpng gtk.libpng.zlib];

  configureFlags = [
    "--enable-gtk2"
    (if compat22 then "--enable-compat22" else "--disable-compat22")
  ];

  inherit gtk compat22;
}
