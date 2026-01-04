{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  vapoursynth,
  opencl-headers,
  ocl-icd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-nnedi3cl";
  version = "8";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-NNEDI3CL";
    tag = "r${finalAttrs.version}";
    hash = "sha256-zW/qEtZTDJOTarXbXhv+nks25eePutLDpLck4TuMKUk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    vapoursynth
    ocl-icd
    opencl-headers
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = {
    description = "Filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-NNEDI3CL";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
})
