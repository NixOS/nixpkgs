{ lib, stdenv, fetchurl, darwin, meson, abseil-cpp, ninja }:

stdenv.mkDerivation rec {
  name = "webrtc-audio-processing-1.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/${name}.tar.gz";
    sha256 = "0vwkw5xw8l37f5vbzbkipjsf03r7b8nnrfbfbhab8bkvf79306j4";
  };

  propagatedBuildInputs = [ abseil-cpp ];
  buildInputs = [ meson ninja ] ++
    lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks;
      [ ApplicationServices ]);

  patchPhase = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  meta = with lib; {
    homepage = "http://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
