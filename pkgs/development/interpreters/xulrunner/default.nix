{stdenv, fetchurl, pkgconfig, gtk, perl, zip, libIDL, libXi}:

stdenv.mkDerivation {
  name = "xulrunner-1.8.0.4";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://releases.mozilla.org/pub/mozilla.org/xulrunner/releases/1.8.0.4/source/xulrunner-1.8.0.4-source.tar.bz2;
    md5 = "4dc09831aa4e94fda5182a4897ed08e9";
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
