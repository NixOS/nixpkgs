{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vapoursynth,
  fftwSinglePrec,
}:

stdenv.mkDerivation {
  pname = "vapoursynth-dfttest";
  version = "unstable-2022-04-15";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-DFTTest";
    rev = "bc5e0186a7f309556f20a8e9502f2238e39179b8";
    hash = "sha256-HGk9yrs6T3LAP0I5GPt9b4LwldXtQDG277ffX6xMr/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
    fftwSinglePrec
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = {
    description = "Plugin for VapourSynth: dfttest";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-DFTTest";
    license = with lib.licenses; [
      gpl3Plus
      asl20
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
}
