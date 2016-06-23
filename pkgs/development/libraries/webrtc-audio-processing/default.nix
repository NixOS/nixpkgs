{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "webrtc-audio-processing-0.1";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/webrtc-audio-processing/${name}.tar.xz";
    sha256 = "1p7yg8n39wwdfr52br2dq3bh8iypfx9md99mh1i9g2v8qbwm4jzd";
  };

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing;
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
