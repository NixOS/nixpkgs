{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wamr";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasm-micro-runtime";
    rev = "WAMR-${finalAttrs.version}";
    hash = "sha256-2jZnvfW/f928DxVwd+z/BVPNPWfbyV8Rjek23NQhFz8=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinSdkVersion}"
  ];

  sourceRoot = let
    platform = if stdenv.isLinux then
        "linux"
      else if stdenv.isDarwin then
        "darwin"
      else throw "unsupported platform";
  in "${finalAttrs.src.name}/product-mini/platforms/${platform}";

  meta = with lib; {
    description = "WebAssembly Micro Runtime";
    homepage = "https://github.com/bytecodealliance/wasm-micro-runtime";
    license = licenses.asl20;
    mainProgram = "iwasm";
    maintainers = with maintainers; [ ereslibre ];
    platforms = platforms.unix;
  };
})
