{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "webrtc-audio-processing-0.3";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/webrtc-audio-processing/${name}.tar.xz";
    sha256 = "1yl0187xjh1j2zkb7v9cs9i868zcaj23pzn4a36qhzam9wfjjvkm";
  };

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing;
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
