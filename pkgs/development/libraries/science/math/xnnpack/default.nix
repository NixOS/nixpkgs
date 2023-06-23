{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
  # buildInputs
  cpuinfo,
  fp16,
  fxdiv,
  libpfm,
  pthreadpool,
  # Configuration options
  buildSharedLibs ? true,
}: let
  setBuildSharedLibrary = bool:
    if bool
    then "shared"
    else "static";
in
  stdenv.mkDerivation (finalAttrs: {
    strictDeps = true;
    pname = "XNNPACK";
    version = finalAttrs.src.rev;
    src = fetchFromGitHub {
      owner = "google";
      repo = finalAttrs.pname;
      rev = "bc76fa1cd86ad73064241a257113a84e14bda1fe";
      hash = "sha256-GHFi+v2rORu61V2d2oYQvAFXzrzeXOSnKjRRNvoo4bY=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/google/XNNPACK/pull/5031.patch";
        hash = "sha256-6cJ5bi59G5XfTDdCy83bLPlm3LMAK7Mg6eyk3QMAt5A=";
      })
    ];
    nativeBuildInputs = [
      cmake
      ninja
    ];
    buildInputs = [
      cpuinfo
      fp16
      fxdiv
      libpfm
      pthreadpool
    ];
    # NOTE: USE_SYSTEM_LIBS doesn't seem to be compatible with BUILD_BECHMARKS or BUILD_TESTS.
    # For this reason, doCheck is false.
    # https://github.com/google/XNNPACK/issues/1543
    # See Debain CMake arguments here: https://salsa.debian.org/deeplearning-team/xnnpack/-/blob/master/debian/rules#L8-12
    cmakeFlags = [
      "-DXNNPACK_BUILD_BENCHMARKS:BOOL=OFF"
      "-DXNNPACK_BUILD_TESTS:BOOL=OFF"
      "-DXNNPACK_ENABLE_DWCONV_MULTIPASS:BOOL=ON"
      "-DXNNPACK_LIBRARY_TYPE:STRING=${setBuildSharedLibrary buildSharedLibs}"
      "-DXNNPACK_USE_SYSTEM_LIBS:BOOL=ON"
    ];
    doCheck = false;
    meta = with lib; {
      description = "High-efficiency floating-point neural network inference operators for mobile, server, and Web";
      homepage = "https://github.com/google/XNNPACK";
      license = licenses.bsd2;
      maintainers = with maintainers; [connorbaker];
      platforms = platforms.all;
    };
  })
