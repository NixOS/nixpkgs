{ stdenv, fetchurl
, libXft, pkgconfig, libX11, inputproto
, xrenderSupport ? true, libXrender ? null
, xrandrSupport ? true, libXrandr ? null, randrproto ? null
, xineramaSupport ? true, libXinerama ? null, xineramaproto ? null
, cursorSupport ? true, libXcursor ? null, libXext ? null
, mysqlSupport ? true, mysql ? null
, openglSupport ? false, mesa ? null, libXmu ? null
, cupsSupport ? true, cups ? null
, dbusSupport ? true, dbus ? null
, xfixesSupport ? true, fixesproto ? null, libXfixes ? null
, smSupport ? true, libICE ? null, libSM ? null
, freetypeSupport ? true, fontconfig ? null, freetype ? null
, glibSupport ? true, glib ? null
, openssl, xextproto, zlib, libjpeg, libpng, which
}:

assert xrenderSupport -> libXrender != null;
assert xrandrSupport -> libXrandr != null && randrproto != null;
assert cursorSupport -> libXcursor != null && libXext != null;
assert mysqlSupport -> mysql != null;
assert openglSupport -> mesa != null && libXmu != null;
assert dbusSupport -> dbus != null;
assert cupsSupport -> cups != null;
assert glibSupport -> glib != null;
assert smSupport -> libICE != null && libSM != null;
assert freetypeSupport -> fontconfig != null && freetype != null;

stdenv.mkDerivation {
  name = "qt-4.3.0";

  builder = ./builder.sh;
  hook = ./setup-hook.sh;  
  src = fetchurl {
    url = ftp://ftp.trolltech.com/qt/source/qt-x11-opensource-src-4.3.0.tar.gz;
    sha256 = "0h0liy7sdp5sarhzdfn7ss61d4ky9h0ky8jysg8v3a97sds7ghxb";
  };

  buildInputs = [libXft libXrender libXrandr randrproto xextproto libXinerama xineramaproto libXcursor zlib libjpeg mysql libpng which mesa libXmu openssl dbus cups pkgconfig libXext freetype fontconfig inputproto fixesproto libXfixes glib];

  patchPhase = "sed -e 's@/bin/pwd@pwd@' -i configure; sed -e 's@/usr@/FOO@' -i config.tests/*/*.test -i mkspecs/*/*.conf";
  dontAddPrefix = 1;
  postConfigure = "export LD_LIBRARY_PATH=$(pwd)/lib";
  configureFlags = "
    -v -no-separate-debug-info -release
    -system-zlib -system-libpng -system-libjpeg
    -qt-gif -confirm-license
    ${if openglSupport then "-opengl" else "-no-opengl"}
    ${if xrenderSupport then "-xrender" else "-no-xrender"}
    ${if xrandrSupport then "-xrandr" else "-no-xrandr"}
    ${if xineramaSupport then "-xinerama" else "-no-xinerama"}
    ${if cursorSupport then "-xcursor" else "-no-xcursor"}
    ${if mysqlSupport then "-qt-sql-mysql -L${mysql}/lib/mysql -I${mysql}/include/mysql" else ""}
    ${if dbusSupport then "-qdbus" else "-no-qdbus"}
    ${if cupsSupport then "-cups" else "-no-cups"}
    ${if glibSupport then "-glib" else "-no-glib"}
    ${if xfixesSupport then "-xfixes" else "-no-xfixes"}
    ${if freetypeSupport then "-fontconfig -I${freetype}/include/freetype2" else "-no-fontconfig"}
  ";

  passthru = {inherit mysqlSupport;};
}
