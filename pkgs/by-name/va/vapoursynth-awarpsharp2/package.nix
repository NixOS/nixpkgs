{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  pkg-config,
  vapoursynth,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "vapoursynth-awarpsharp2";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-awarpsharp2";
    rev = "refs/tags/v${lib.versions.major finalAttrs.version}";
    hash = "sha256-wB70gj/WJf+/vLteO05dawPPnvr/22FsDWHOYooF35g=";
  };

  buildInputs = [ vapoursynth ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja # resolves: Could not detect Ninja
  ];

  meta = {
    description = "Sharpens by warping";
    homepage = "https://github.com/dubhater/vapoursynth-awarpsharp2";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.isc;
  };
})
