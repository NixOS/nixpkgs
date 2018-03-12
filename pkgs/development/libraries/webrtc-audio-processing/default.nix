{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "webrtc-audio-processing-0.3";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/webrtc-audio-processing/${name}.tar.xz";
    sha256 = "1yl0187xjh1j2zkb7v9cs9i868zcaj23pzn4a36qhzam9wfjjvkm";
  };

  # Avoid this error:
  # signal_processing/filter_ar_fast_q12_armv7.S:88: Error: selected processor does not support `sbfx r11,r6,#12,#16' in ARM mode
  patchPhase = stdenv.lib.optionalString stdenv.isArm ''
    substituteInPlace configure --replace 'armv7*|armv8*' 'disabled'
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  meta = with stdenv.lib; {
    homepage = http://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing;
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
