{ config, stdenv, fetchurl, pkgconfig, intltool, glib
, alsaSupport ? stdenv.isLinux, alsaLib
, pulseaudioSupport ? config.pulseaudio or true, libpulseaudio
, ossSupport ? false
 }:

stdenv.mkDerivation rec {
  name = "libmatemixer-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1v0gpr55gj4mj8hzxbhgzrmhaxvs2inxhsmirvjw39sc7iplvrh9";
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
