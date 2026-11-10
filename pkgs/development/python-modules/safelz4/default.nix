{
  lib,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  buildPythonPackage,

  # testing
  pytestCheckHook,
  xxhash,
}:

buildPythonPackage (finalAttrs: {
  pname = "safelz4";
  version = "0.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LVivona";
    repo = "safelz4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Nbvycbpt5TzwBZnbQT81savLprH9E0zq6eN3Qxi0/jI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-lJeEdaeMSyG1egRbMPepPfVPI1dL7hZS2bObZ3Rhopw=";
  };

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    pytestCheckHook
    xxhash
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [
    "safelz4"
  ];

  meta = {
    description = "Python bindings for lz4_flex, the fastest pure-Rust implementation of the LZ4 compression algorithm";
    homepage = "https://github.com/LVivona/safelz4";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "slz4";
  };
})
