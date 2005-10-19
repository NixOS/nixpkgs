{stdenv, fetchurl, pkgconfig, gtk, libXinerama, compat22 ? true}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.6.2";

  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/wxwindows/wxGTK-2.6.2.tar.bz2;
    md5 = "ba2afe7bd028062c5fff6d5ef3249c67";
  };

  buildInputs = [
    pkgconfig gtk gtk.libtiff gtk.libjpeg gtk.libpng gtk.libpng.zlib
    libXinerama
  ];

  configureFlags = [
    "--enable-gtk2"
    (if compat22 then "--enable-compat22" else "--disable-compat22")
    "--disable-precomp-headers"
  ];

  inherit gtk compat22;
}
