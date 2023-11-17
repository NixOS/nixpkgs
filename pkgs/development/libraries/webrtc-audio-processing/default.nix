{ lib
, stdenv
, fetchFromGitLab
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

  meta = with lib; {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/master/webrtc/rtc_base/system/arch.h
    # x86-32 disabled due to https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/5
    platforms = intersectLists platforms.unix (platforms.aarch64 ++ platforms.mips ++ platforms.riscv ++ platforms.x86_64);
  };
}
