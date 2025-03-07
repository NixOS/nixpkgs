{ lib, stdenv, fetchurl, fetchpatch, darwin }:

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
    # big-endian support, from https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/127
    (fetchpatch {
      name = "0001-webrtc-audio-processing-big-endian.patch";
      url = "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/uploads/2994c0512aaa76ebf41ce11c7b9ba23e/webrtc-audio-processing-0.2-big-endian.patch";
      hash = "sha256-zVAj9H8SJureQd0t5O5v1je4ia8/gHJOXYxuEBEB6gg=";
    })
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices ]);

  patchPhase = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "More Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/v0.3.1/webrtc/typedefs.h
    # + our patches
    platforms = intersectLists platforms.unix (platforms.arm ++ platforms.aarch64 ++ platforms.mips ++ platforms.power ++ platforms.riscv ++ platforms.x86);
  };
}
