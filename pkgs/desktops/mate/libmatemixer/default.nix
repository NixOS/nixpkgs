{ config, stdenv, fetchurl, pkgconfig, gettext, glib
, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? config.pulseaudio or true, libpulseaudio
, ossSupport ? false
 }:

stdenv.mkDerivation rec {
  pname = "libmatemixer";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1n6rq7k66zvfd6sb7h92xihh021w9hysfa4yd1mzjcbb7c62ybqx";
  };

  nativeBuildInputs = [ pkgconfig gettext ];

  buildInputs = [ glib ]
    ++ stdenv.lib.optional alsaSupport alsaLib
    ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = stdenv.lib.optional ossSupport "--enable-oss";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Mixer library for MATE";
    homepage = "https://github.com/mate-desktop/libmatemixer";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
