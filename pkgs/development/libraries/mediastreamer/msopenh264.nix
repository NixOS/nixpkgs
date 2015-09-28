{ stdenv, fetchurl, autoreconfHook, pkgconfig, mediastreamer, openh264 }:

stdenv.mkDerivation rec {
  name = "mediastreamer-openh264-${version}";
  version = "1.0.0";

  src = fetchurl {
    url = "http://download-mirror.savannah.gnu.org/releases/linphone/plugins/sources/msopenh264-${version}.tar.gz";
    sha256 = "1622ma8g4yqvxa8pqwddsmhlpwak31i8zfl88f60k71k4dplw845";
  };

  buildInputs = [ autoreconfHook pkgconfig mediastreamer openh264 ];

  meta = with stdenv.lib; {
    description = "H.264 encoder/decoder plugin for mediastreamer2";
    homepage = http://www.linphone.org/technical-corner/mediastreamer2/overview;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
