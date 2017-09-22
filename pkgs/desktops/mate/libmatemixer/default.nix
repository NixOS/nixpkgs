{ stdenv, fetchurl, pkgconfig, intltool, glib
, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? stdenv.config.pulseaudio or true, libpulseaudio
, ossSupport ? false
 }:

stdenv.mkDerivation rec {
  name = "libmatemixer-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "09vyxnlnalws318gsafdfi5c6jwpp92pbafn1ddlqqds23ihk4mr";
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
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
