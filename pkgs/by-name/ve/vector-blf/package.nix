{
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  boost,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vector-blf";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "Technica-Engineering";
    repo = "vector_blf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KtAvSkDs8/ZvZ9r0EjQIstMa4RHOdKDDE+ia4hGP8aA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zlib
  ];

  checkInputs = [
    boost
  ];

  patches = [
    ./001-fix-cstdint-include.patch
    ./002-fix-pkg-config-file.patch
    ./003-fix-boost-cmake.patch
  ];

  cmakeFlags = [
    (lib.cmakeBool "OPTION_RUN_DOXYGEN" false)
    (lib.cmakeBool "OPTION_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Library to access Binary Log File (BLF) files";
    homepage = "https://github.com/Technica-Engineering/vector_blf";
    changelog = "https://github.com/Technica-Engineering/vector_blf/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      AhmedAmr
    ];
    teams = with lib.teams; [ ngi ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
