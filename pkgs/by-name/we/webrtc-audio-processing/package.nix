{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  abseil-cpp,
  meson,
  ninja,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webrtc-audio-processing";
  version = "2.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "pulseaudio";
    repo = "webrtc-audio-processing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YR4ELukJgHMbfe80H+r8OiaZUCAqefGXmVOaTVVgOqA=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-15-compat.patch";
      url = "https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/commit/e9c78dc4712fa6362b0c839ad57b6b46dce1ba83.diff";
      hash = "sha256-QXOtya7RA0UTV9VK4qpql5D8QcOKAn6qURZvPpWT+vg=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    abseil-cpp
  ];

  mesonFlags =
    lib.lists.optional (!stdenv.hostPlatform.isAarch64) "-Dneon=disabled"
    ++ lib.lists.optional (stdenv.hostPlatform.isi686) "-Dinline-sse=false";

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    homepage = "https://www.freedesktop.org/software/pulseaudio/webrtc-audio-processing";
    description = "More Linux packaging friendly copy of the AudioProcessing module from the WebRTC project";
    pkgConfigModules = [ "webrtc-audio-processing-2" ];
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fzdslr ];
    platforms =
      with lib.platforms;
      lib.intersectLists
        # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/master/webrtc/rtc_base/system/arch.h
        (arm ++ aarch64 ++ mips ++ power ++ riscv ++ x86 ++ loongarch64)
        # https://gitlab.freedesktop.org/pulseaudio/webrtc-audio-processing/-/blob/master/meson.build
        (linux ++ windows ++ freebsd ++ netbsd ++ openbsd ++ darwin);
  };
})
