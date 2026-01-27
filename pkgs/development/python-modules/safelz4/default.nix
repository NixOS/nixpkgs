{
  lib,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  buildPythonPackage,

  # testing
  hypothesis,
  pytestCheckHook,
  pytest-benchmark,
  setuptools-rust,
  xxhash,
}:

buildPythonPackage (finalAttrs: {
  pname = "safelz4";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LVivona";
    repo = "safelz4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4pCykt2WsR/Ij/ylwKHLY/NYBdDLlZjMY2BX3ld9T4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  build-system = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-benchmark
    setuptools-rust
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
