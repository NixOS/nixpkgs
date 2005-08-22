{stdenv, fetchurl, pkgconfig, gtk, libXinerama, compat22 ? true}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.5.2";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/wxGTK-2.5.2.tar.bz2;
    md5 = "b45874428b0164bfa5bd1a5a11b3eb4a";
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
