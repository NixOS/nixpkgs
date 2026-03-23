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
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-bestsource";
  version = "16";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "vapoursynth";
    repo = "bestsource";
    tag = "R${finalAttrs.version}";
    hash = "sha256-t8dRP53hw68VElVV3og6WkNE75lmKx8llQVsfpg49+0=";
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
      --replace-fail "vapoursynth_dep.get_variable('libdir') / 'vapoursynth'" "get_option('libdir')"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "R";
    ignoredVersions = "*-RC*";
  };

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
