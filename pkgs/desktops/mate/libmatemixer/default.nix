{ stdenv, fetchurl, pkgconfig, intltool, glib, mate
, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio
, ossSupport ? false
 }:

stdenv.mkDerivation rec {
  name = "libmatemixer-${version}";
  version = "1.20.1";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "00p67mi0flsbgn15qpwq60rzf917s5islbmhirbvz6npcvv0d493";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ glib ]
    ++ stdenv.lib.optional alsaSupport alsaLib
    ++ stdenv.lib.optional pulseaudioSupport libpulseaudio;

  configureFlags = stdenv.lib.optional ossSupport "--enable-oss";

  meta = with stdenv.lib; {
    description = "Mixer library for MATE";
    homepage = https://github.com/mate-desktop/libmatemixer;
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
