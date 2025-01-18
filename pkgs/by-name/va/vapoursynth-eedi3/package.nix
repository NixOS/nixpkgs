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
  openclSupport ? true,
}:

stdenv.mkDerivation {
  pname = "vapoursynth-eedi3";
  version = "unstable-2019-09-30";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = "d11bdb37c7a7118cd095b53d9f8fbbac02a06ac0";
    hash = "sha256-MIUf6sOnJ2uqGw3ixEHy1ijzlLFkQauwtm1vfgmYmcg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      boost
      vapoursynth
    ]
    ++ lib.optionals openclSupport [
      ocl-icd
      opencl-headers
    ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonFlags = [ (lib.mesonBool "opencl" openclSupport) ];

  meta = with lib; {
    description = "Filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ snaki ];
    platforms = platforms.x86_64;
  };
}
