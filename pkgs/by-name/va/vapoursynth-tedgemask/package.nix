{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  cmake,
  pkg-config,
  vapoursynth,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-tedgemask";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = "vapoursynth-tedgemask";
    rev = "refs/tags/v${lib.versions.major finalAttrs.version}";
    hash = "sha256-7ODhuW6UAG6TltuNNOWUWE9JbB6rXYcoGp/j7okXS5I=";
  };

  buildInputs = [ vapoursynth ];
  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja # resolves: Could not detect Ninja
  ];

  meta = {
    description = "Edge detection filter";
    homepage = "https://github.com/dubhater/vapoursynth-tedgemask";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.gpl2Only;
  };
})
