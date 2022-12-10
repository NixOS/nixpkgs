{ lib, stdenv, fetchurl
, darwin
, abseil-cpp_202111
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "webrtc-audio-processing";
  version = "1.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/archive/v1.0/webrtc-audio-processing-v${version}.tar.gz";
    sha256 = "sha256-dqRy1OfOG9TX2cgCD8cowU44zVanns/nPYZrilPfuiU=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  buildInputs = [
    abseil-cpp_202111
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ ApplicationServices ]);

  patchPhase = ''
    # this is just incorrect upstream
    # see https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/4
    substituteInPlace meson.build \
      --replace "absl_flags_registry" "absl_flags_reflection"
    '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace webrtc/base/checks.cc --replace 'defined(__UCLIBC__)' 1
  '';

  meta = with lib; {
    homepage = "http://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "A more Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    license = licenses.bsd3;
    # attempts to inline 256bit AVX instructions on x86
    # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/issues/5
    platforms = lib.lists.subtractLists platforms.i686 platforms.unix;
  };
}
