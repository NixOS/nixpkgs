{ lib
, stdenv
, fetchFromGitLab
, fetchurl
, darwin
, abseil-cpp
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "webrtc-audio-processing";
  version = "1.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pulseaudio";
    repo = "webrtc-audio-processing";
    rev = "v${version}";
    hash = "sha256-8CDt4kMt2Owzyv22dqWIcFuHeg4Y3FxB405cLw3FZ+g=";
  };

  patches = [
    # Fix an include oppsie that happens to not happen on glibc
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/merge_requests/38
    (fetchurl {
      url = "https://git.alpinelinux.org/aports/plain/community/webrtc-audio-processing-1/0001-rtc_base-Include-stdint.h-to-fix-build-failures.patch?id=625e19c19972e69e034c0870a31b375833d1ab5d";
      hash = "sha256-9nI22SJoU0H3CzsPSAObtCFTadtvkzdnqIh6mxmUuds=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    abseil-cpp
  ];

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices Foundation ]);

  env = lib.optionalAttrs stdenv.isx86_32 {
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/5
    NIX_CFLAGS_COMPILE = "-msse2";
  };

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "More Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/master/webrtc/rtc_base/system/arch.h
    platforms = intersectLists platforms.unix (platforms.arm ++ platforms.aarch64 ++ platforms.mips ++ platforms.power ++ platforms.riscv ++ platforms.x86);
    # BE platforms are unsupported
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/31
    badPlatforms = platforms.bigEndian;
  };
}
