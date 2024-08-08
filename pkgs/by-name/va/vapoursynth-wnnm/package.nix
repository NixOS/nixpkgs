{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  mkl,
  vapoursynth,
  zimg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vapoursynth-wnnm";
  version = "unstable-2023-07-07";

  srcs = [
    (fetchFromGitHub {
      owner = "WolframRhodium";
      repo = "VapourSynth-WNNM";
      rev = "a8977b4365841bb27c232383cd9a306f70ef9f99";
      name = "${finalAttrs.pname}-source";
      hash = "sha256-B4jvl+Lu724QofDbKQObdcpQdlb8KQ2szAp780J9SUY=";
    })
    (fetchFromGitHub {
      owner = "vectorclass";
      repo = "version2";
      rev = "refs/tags/v2.02.01";
      name = "vectorclass";
      hash = "sha256-45qt0vGz6ibEmcoPZDOeroSivoVnFkvMEihjXJXa8lU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    (mkl.override { enableStatic = true; })
    vapoursynth
    zimg
  ];

  sourceRoot = "${finalAttrs.pname}-source";

  preConfigure = ''
    cmakeFlagsArray=(${lib.escapeShellArg (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-ffast-math -mavx2 -mfma")})
  '';

  cmakeFlags = [
    (lib.cmakeFeature "VCL_HOME" (toString (lib.last finalAttrs.srcs)))
    (lib.cmakeFeature "MKL_LINK" "static")
    (lib.cmakeFeature "MKL_INTERFACE" "lp64")
    (lib.cmakeFeature "MKL_THREADING" "sequential")
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${VS_LIBDIR}" "lib"
  '';

  meta = {
    description = "Plugin for VapourSynth: wnnm";
    homepage = "https://github.com/WolframRhodium/VapourSynth-WNNM";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ snaki ];
    platforms = lib.platforms.x86_64;
  };
})
