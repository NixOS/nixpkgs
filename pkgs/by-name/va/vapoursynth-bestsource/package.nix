{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  cmake,
  pkg-config,
  vapoursynth,
  ffmpeg,
  xxHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-bestsource";
  version = "6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "refs/tags/R${finalAttrs.version}";
    hash = "sha256-ICkdIomlkHUdK6kMeui45fvUn4OMxSrP8svB2IN+GCg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    ffmpeg
    xxHash
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" "get_option('libdir')"
  '';

  meta = {
    description = "Wrapper library around FFmpeg that ensures sample and frame accurate access to audio and video";
    homepage = "https://github.com/vapoursynth/bestsource";
    license = with lib.licenses; [
      mit
      wtfpl
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.all;
  };
})
