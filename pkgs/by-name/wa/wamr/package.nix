{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamr";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    rev = "WAMR-${finalAttrs.version}";
    hash = "sha256-Qz1Onig++J4V2dpse6n8WADEuJPqTpXK5B+fQml8C2E=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags =
    [
      "-DWAMR_BUILD_SIMD=0"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinSdkVersion}"
    ];

  postPatch =
    let
      # Can't use `sourceRoot` because we need the entire
      # source tree to be writable, as the CMake scripts
      # write to it.
      sourceDir =
        let
          platform =
            if stdenv.hostPlatform.isLinux then
              "linux"
            else if stdenv.hostPlatform.isDarwin then
              "darwin"
            else
              throw "unsupported platform";
        in
        "product-mini/platforms/${platform}";
    in
    ''
      cd ${sourceDir}
    '';

  meta = with lib; {
    description = "WebAssembly Micro Runtime";
    homepage = "https://github.com/bytecodealliance/wasm-micro-runtime";
    license = licenses.asl20;
    mainProgram = "iwasm";
    maintainers = with maintainers; [ ereslibre ];
    platforms = platforms.unix;
  };
})
