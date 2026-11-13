{
  cmake,
  lib,
  nvtx,
  stdenv,
}:
let
  inherit (lib.strings) cmakeBool;
in
# Runs the upstream test suite, which covers the C and C++ APIs, injection, and the exported API. It builds against
# NVTX's sources rather than the installed package (tests.cmake checks that), so it checks the release being packaged.
stdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${nvtx.name}-upstream-tests";

  inherit (nvtx) src;

  sourceRoot = "${nvtx.src.name}/tests";

  nativeBuildInputs = [ cmake ];

  # The tests of the CUDA APIs require a GPU and are not run.
  cmakeFlags = [ (cmakeBool "ENABLE_CUDA" false) ];

  doCheck = true;

  installPhase = ''
    runHook preInstall
    touch "$out"
    runHook postInstall
  '';
}
