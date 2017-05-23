{ stdenv, fetchurl, pkgconfig, cmake
, aspell, hspell, jasper, cups, libidn
, openexr, pcre , libutempter, libxslt
, libxml2, glib, openssl
, libudev # not detected in the configure phase
, file # libmagic
, xorg, tde }:

let baseName = "tdelibs"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "1n8ifbfgly0cr254ksnvqfzrkrnhsl8qy0grjxsajaxiizfm3gzs";
  };

  patches = [ ./0001-fix-kdoctools-configurechecks.patch ];

  nativeBuildInputs = [ pkgconfig cmake ];

  buildInputs =
  [ aspell hspell jasper cups libxml2 libxslt libidn
    openexr pcre libutempter file glib openssl libudev
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
