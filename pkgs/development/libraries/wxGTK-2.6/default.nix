{stdenv, fetchurl, pkgconfig, gtk, libXinerama, compat22 ? true, unicode ? true}:

assert pkgconfig != null && gtk != null;
assert gtk.libtiff != null;
assert gtk.libjpeg != null;
assert gtk.libpng != null;
assert gtk.libpng.zlib != null;

stdenv.mkDerivation {
  name = "wxGTK-2.6.4";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/wxwindows/wxGTK-2.6.4.tar.gz;
    sha256 = "1yilzg9qxvdpqhhd3sby1w9pj00k7jqw0ikmwyhh5jmaqnnnrb2x";
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

  postBuild = "(cd contrib/src && make)";
  postInstall = "
    (cd contrib/src && make install)
    (cd $out/include && ln -s wx-*/* .)
  ";

  inherit gtk compat22;
}
