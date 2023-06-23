{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  # buildInputs
  psimd,
  # checkInputs
  gbenchmark,
  gtest,
}: let
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "FP16";
    version = finalAttrs.src.rev;
    src = fetchFromGitHub {
      owner = "Maratyszcza";
      repo = finalAttrs.pname;
      rev = "0a92994d729ff76a58f692d3028ca1b64b145d91";
      hash = "sha256-m2d9bqZoGWzuUPGkd29MsrdscnJRtuIkLIMp3fMmtRY=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/Maratyszcza/FP16/pull/23.patch";
        hash = "sha256-a2K4IYyjae29HTUHd86THCzdJhxHFieTGYayw/Ge/GM=";
      })
    ];
    nativeBuildInputs = [
      cmake
      ninja
    ];
    buildInputs = [psimd];
    cmakeFlags = [
      "-DFP16_BUILD_BENCHMARKS:BOOL=${setBool finalAttrs.doCheck}"
      "-DFP16_BUILD_TESTS:BOOL=${setBool finalAttrs.doCheck}"
      "-DUSE_SYSTEM_LIBS:BOOL=ON"
    ];
    doCheck = true;
    checkInputs = [
      gbenchmark
      gtest
    ];
    meta = with lib; {
      description = "Header-only library for conversion to/from half-precision floating point formats";
      homepage = "https://github.com/Maratyszcza/FP16";
      license = licenses.mit;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
