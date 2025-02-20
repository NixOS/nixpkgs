{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  ffmpeg,
  xxHash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-bestsource";
  version = "10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "vapoursynth";
    repo = "bestsource";
    tag = "R${finalAttrs.version}";
    hash = "sha256-zqQsyfB2POa+9IekwxJWdLToX2wY7ZR/hoENhGRuvhI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    (ffmpeg.override { withLcms2 = true; })
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
