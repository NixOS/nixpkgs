{ lib, stdenv, fetchurl, darwin }:

stdenv.mkDerivation rec {
  pname = "webrtc-audio-processing";
  version = "0.3.1";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${version}.tar.xz";
    sha256 = "1gsx7k77blfy171b6g3m0k0s0072v6jcawhmx1kjs9w5zlwdkzd0";
  };

  outputs = [ "out" "dev" ];

  patches = [
    ./enable-riscv.patch
    ./enable-powerpc.patch
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices ]);

  patchPhase = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  meta = {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "More Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = lib.licenses.bsd3;
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/v0.3.1/webrtc/typedefs.h
    # + our patches
    platforms = lib.intersectLists lib.platforms.unix (lib.platforms.arm ++ lib.platforms.aarch64 ++ lib.platforms.mips ++ lib.platforms.power ++ lib.platforms.riscv ++ lib.platforms.x86);
  };
}
