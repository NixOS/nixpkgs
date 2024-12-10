{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  capnproto,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "UHDM";
  # When updating this package, also consider updating science/logic/surelog
  version = "1.83";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "UHDM";
    rev = "v${finalAttrs.version}";
    hash = "sha256-va8qAzsg589C6rLmG1uIMDr4X30qpBgRO1ZVKdEs5ok=";
    fetchSubmodules = false; # we use all dependencies from nix
  };

  nativeBuildInputs = [
    cmake
    (python3.withPackages (p: with p; [ orderedmultidict ]))
    gtest
  ];

  buildInputs = [
    capnproto
  ];

  cmakeFlags = [
    "-DUHDM_USE_HOST_GTEST=On"
    "-DUHDM_USE_HOST_CAPNP=On"
  ];

  doCheck = true;
  checkPhase = "make test";

  meta = {
    description = "Universal Hardware Data Model";
    homepage = "https://github.com/chipsalliance/UHDM";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
})
