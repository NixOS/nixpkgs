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
  name = "vs-removegrain";
  version = "1.0.0-unstable-2022-10-28";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vs-removegrain";
    rev = "89ca38a6971e371bdce2778291393258daa5f03b";
    hash = "sha256-UcS8EjZGCX00Pt5pAxBTzCiveTKS5yeFT+bQgXKnJ+k=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
        "install_dir : join_paths(vapoursynth_dep.get_pkgconfig_variable('libdir'), 'vapoursynth')," \
        "install_dir : join_paths('${placeholder "out"}/lib/', 'vapoursynth'),"
  '';

  buildInputs = [ vapoursynth ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja # resolves: Could not detect Ninja
  ];

  meta = {
    description = "VapourSynth port of RemoveGrain and Repair plugins from Avisynth";
    homepage = "https://github.com/vapoursynth/vs-removegrain";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.wtfpl;
  };
})
