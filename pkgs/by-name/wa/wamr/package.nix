{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamr";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    rev = "WAMR-${finalAttrs.version}";
    hash = "sha256-jrJ9aO/nc6TEUjehMm0deBtCXpx22YBSKyEB/Dzbc3c=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
        # Remove version.h generation since it already exists and source is read-only
        substituteInPlace ../../../build-scripts/version.cmake \
          --replace "configure_file(
      \''${WAMR_ROOT_DIR}/core/version.h.in
      \''${WAMR_ROOT_DIR}/core/version.h
    )" ""
  '';

  cmakeFlags =
    [
      "-DWAMR_BUILD_SIMD=0" # Disable SIMD to avoid fetching simde dependency
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinSdkVersion}"
    ];

  sourceRoot =
    let
      platform =
        if stdenv.hostPlatform.isLinux then
          "linux"
        else if stdenv.hostPlatform.isDarwin then
          "darwin"
        else
          throw "unsupported platform";
    in
    "${finalAttrs.src.name}/product-mini/platforms/${platform}";

  meta = with lib; {
    description = "WebAssembly Micro Runtime";
    homepage = "https://github.com/bytecodealliance/wasm-micro-runtime";
    license = licenses.asl20;
    mainProgram = "iwasm";
    maintainers = with maintainers; [
      ereslibre
      bubblepipe
    ];
    platforms = platforms.unix;
  };
})
