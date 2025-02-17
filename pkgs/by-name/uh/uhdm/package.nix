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
  version = "1.84-unstable-2024-11-12";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "UHDM";
    # After we're back on a stable tag, use v${finalAttrs.version}
    rev = "7d90dd0e68759775d0c86885d991925096b5b496";
    hash = "sha256-msdtBAlOXwYJd0HhWmVo8oMJ6h8OUmy0ILxV1MV52PE=";
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
