{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "webrtc-audio-processing";
  version = "0.3.1";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/webrtc-audio-processing/webrtc-audio-processing-${version}.tar.xz";
    sha256 = "1gsx7k77blfy171b6g3m0k0s0072v6jcawhmx1kjs9w5zlwdkzd0";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./enable-riscv.patch
    ./enable-powerpc.patch
    # big-endian support, from https://gitlab.freedesktop.org/pulseaudio/pulseaudio/-/issues/127
    (fetchpatch {
      name = "0001-webrtc-audio-processing-big-endian.patch";
      url = "https://gitlab.freedesktop.org/pulseaudio/pulseaudio/uploads/2994c0512aaa76ebf41ce11c7b9ba23e/webrtc-audio-processing-0.2-big-endian.patch";
      hash = "sha256-zVAj9H8SJureQd0t5O5v1je4ia8/gHJOXYxuEBEB6gg=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/2f3c3b1d9dadc25356da4b612130bf4dea27b817/audio/webrtc-audio-processing0/files/patch-configure.ac";
      hash = "sha256-IOSW3ZLIuRXY/M+MU813M9o0Vu4mcGoAtdNRlJwESHw=";
      extraPrefix = "";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/27f26f19a34755fe4b939a7210d8ba7ee9358a0d/audio/webrtc-audio-processing0/files/patch-webrtc_base_stringutils.h";
      hash = "sha256-j85CdFpDIPhhEquwA3P0r5djnMEGVnvfsPM2bYbURt8=";
      extraPrefix = "";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/freebsd/freebsd-ports/0d316feccaf89c1bd804d6001274426a7135c93a/audio/webrtc-audio-processing0/files/patch-webrtc_base_platform__thread.cc";
      hash = "sha256-MsZtNWv3bwxJLxpQaMqj34XIBhqAaO2NkBHjlFWZreA=";
      extraPrefix = "";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "More Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/v0.3.1/webrtc/typedefs.h
    # + our patches
    platforms = intersectLists platforms.unix (
      platforms.arm
      ++ platforms.aarch64
      ++ platforms.mips
      ++ platforms.power
      ++ platforms.riscv
      ++ platforms.x86
    );
  };
}
