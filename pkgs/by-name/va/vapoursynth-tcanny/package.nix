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
  pname = "vapoursynth-tcanny";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-TCanny";
    rev = "refs/tags/r${lib.versions.major finalAttrs.version}";
    hash = "sha256-UUYb9UFZ3oB05hAW/FvvM0a8nyJlQnynZSSajF2l/U0=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "install_dir = get_option('libdir') / 'vapoursynth'" \
        "install_dir = '${placeholder "out"}/lib/vapoursynth'" \
      --replace-fail \
        "install_dir = vapoursynth_dep.get_variable(pkgconfig: 'libdir') / 'vapoursynth'" \
        "install_dir = '${placeholder "out"}/lib/vapoursynth'"
  '';

  buildInputs = [ vapoursynth ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja # resolves: Could not detect Ninja
  ];

  meta = {
    description = "Filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-TCanny";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.gpl3Only;
  };
})
