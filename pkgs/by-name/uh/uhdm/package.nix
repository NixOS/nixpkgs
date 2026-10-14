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
  pname = "uhdm";
  # When updating this package, also consider updating surelog
  version = "1.87";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "UHDM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kCCNe1elZoExc8OAtvRxwKODxCdNuVzjFQkEMntNjqI=";
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

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

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
