{ stdenv, fetchurl, pkgconfig, cmake
, aspell, hspell, jasper, cups, libidn
, openexr, pcre , libutempter, libxslt
, libxml2, glib, openssl
, libudev # not detected in the configure phase
, file # libmagic
, xorg, tde }:

stdenv.mkDerivation rec{

  name = "tdelibs-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14";
  minorVer = "0.3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "18yxw4q87zm2wxxpmchals89iqj2ppkc1wjb0vd0pmwlblb7nygz";
  };

  patches = [ ./0001-fix-kdoctools-configurechecks.patch ];

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs =
  [ aspell hspell jasper cups libxml2 libxslt libidn openexr
    pcre libutempter file glib openssl libudev
    xorg.iceauth xorg.libXtst xorg.libXrandr xorg.libXcomposite
    tde.tqtinterface tde.arts tde.libart-lgpl tde.dbus-tqt ];

  meta = with stdenv.lib;{
    description = "TDE Libraries";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
