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

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-bm3d";
  version = "9";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-BM3D";
    rev = "refs/tags/r${finalAttrs.version}";
    hash = "sha256-i7Kk7uFt2Wo/EWpVkGyuYgGZxBuQgOT3JM+WCFPHVrc=";
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
    inherit (vapoursynth.meta) platforms;
    description = "Plugin for VapourSynth: bm3d";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-BM3D";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ snaki ];
  };
})
