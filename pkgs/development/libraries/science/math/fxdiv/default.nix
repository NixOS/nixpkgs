{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  # checkInputs
  gbenchmark,
  gtest,
  # Configuration options
  useInlineAssembly ? false,
}: let
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "FXdiv";
    version = finalAttrs.src.rev;
    src = fetchFromGitHub {
      owner = "Maratyszcza";
      repo = finalAttrs.pname;
      rev = "63058eff77e11aa15bf531df5dd34395ec3017c8";
      hash = "sha256-LjX5kivfHbqCIA5pF9qUvswG1gjOFo3CMpX0VR+Cn38=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/Maratyszcza/FXdiv/pull/5.patch";
        hash = "sha256-yKY1iSd1AWm7eHeRX+KvEqq6qrHDPdELOoHTbOr2BI0=";
      })
    ];
    nativeBuildInputs = [
      cmake
      ninja
    ];
    cmakeFlags = [
      "-DUSE_SYSTEM_LIBS:BOOL=ON"
      "-DFXDIV_BUILD_BENCHMARKS:BOOL=${setBool finalAttrs.doCheck}"
      "-DFXDIV_BUILD_TESTS:BOOL=${setBool finalAttrs.doCheck}"
      "-DFXDIV_USE_INLINE_ASSEMBLY:BOOL=${setBool useInlineAssembly}"
    ];
    doCheck = true;
    checkInputs = [
      gbenchmark
      gtest
    ];
    meta = with lib; {
      description = "Header-only library for division via fixed-point multiplication by inverse";
      homepage = "https://github.com/Maratyszcza/FXdiv";
      license = licenses.mit;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
