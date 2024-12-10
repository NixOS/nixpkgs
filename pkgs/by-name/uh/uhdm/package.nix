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
  version = "1.84-unstable-2024-10-06";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "UHDM";
    # After we're back on a stable tag, use v${finalAttrs.version}
    rev = "857f68de3ce5b6f919f3a0f489c93072751b1578";
    hash = "sha256-qHcRncsvMiSJji+JLOlfQ87+pfKg+zvlqMTXKpImvTM=";
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
    maintainers = with lib.maintainers; [
      matthuszagh
      hzeller
    ];
    platforms = lib.platforms.all;
  };
})
