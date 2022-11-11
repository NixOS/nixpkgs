{ lib, stdenv, fetchurl, darwin }:

stdenv.mkDerivation rec {
  pname = "webrtc-audio-processing";
  version = "0.3.1";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${version}.tar.xz";
    sha256 = "1gsx7k77blfy171b6g3m0k0s0072v6jcawhmx1kjs9w5zlwdkzd0";
  };

  patches = [
    ./enable-riscv.patch
    ./enable-powerpc.patch
  ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices ]);

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
