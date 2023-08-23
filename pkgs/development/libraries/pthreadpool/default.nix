{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  # buildInputs
  fxdiv,
  # checkInputs
  gbenchmark,
  gtest,
  # Configuration options
  buildSharedLibs ? true,
}: let
  setBool = bool:
    if bool
    then "ON"
    else "OFF";
  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "pthreadpool";
    version = finalAttrs.src.rev;
    src = fetchFromGitHub {
      owner = "Maratyszcza";
      repo = finalAttrs.pname;
      rev = "0961e3449544d147a8486f43a3fdbb4e5d66e162";
      hash = "sha256-IepLMbB0TILECDiFC7f2gdHoSVKvYRDDtRBHj2trdBE=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/Maratyszcza/pthreadpool/pull/27.patch";
        hash = "sha256-ouGnLqRcep2ZsrWepRHafE1sRc7j8b9DTsUqObStIS4=";
      })
    ];
    nativeBuildInputs = [
      cmake
      ninja
    ];
    buildInputs = [fxdiv];
    cmakeFlags = [
      "-DBUILD_SHARED_LIBS:STRING=${setBuildSharedLibrary buildSharedLibs}"
      "-DPTHREADPOOL_ALLOW_DEPRECATED_API:BOOL=ON"
      "-DPTHREADPOOL_BUILD_BENCHMARKS:BOOL=${setBool finalAttrs.doCheck}"
      "-DPTHREADPOOL_BUILD_TESTS:BOOL=${setBool finalAttrs.doCheck}"
      "-DUSE_SYSTEM_LIBS:BOOL=ON"
    ];
    doCheck = true;
    checkInputs = [
      gbenchmark
      gtest
    ];
    meta = with lib; {
      description = "Portable (POSIX/Windows/Emscripten) thread pool for C/C++";
      homepage = "https://github.com/Maratyszcza/pthreadpool";
      license = licenses.bsd2;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
