{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

stdenv.mkDerivation {
  name = "xulrunner-1.8.0.1";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.mozilla.org/pub/mozilla.org/xulrunner/releases/1.8.0.1/source/xulrunner-1.8.0.1-source.tar.bz2;
    md5 = "d60ccb6cc28afa7d880c8602a2c88450";
  };

  buildInputs = [pkgconfig gtk perl zip libIDL libXi];
  configureFlags = [
    "--enable-application=xulrunner"
    "--enable-optimize"
    "--disable-debug"
    "--enable-xft"
    "--disable-freetype2"
    "--enable-svg"
    "--enable-strip"
    "--enable-default-toolkit=gtk2"
    "--with-system-jpeg"
    "--with-system-png"
    "--with-system-zlib"
    "--disable-gnomevfs"
    "--disable-gnomeui"
    "--disable-javaxpcom"
    ];
}
