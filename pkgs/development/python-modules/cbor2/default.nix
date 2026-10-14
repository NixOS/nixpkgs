{
  lib,
  buildPythonPackage,
  cargo,
  fetchFromGitHub,
  hypothesis,
  pytest-cov-stub,
  pytestCheckHook,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  setuptools-scm,
  withCExtensions ? true,
}:

buildPythonPackage (finalAttrs: {
  pname = "cbor2";
  version = "6.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "cbor2";
    tag = finalAttrs.version;
    hash = "sha256-DAhMoWZ820bfa7u+Mu+uqQ+ci+ibxQGwP70t4eOCHg8=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-L9aYpPNGWf8h/NCjDwj5qper9sMSTCxPL91eIbb4hw0=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  build-system = [
    setuptools
    setuptools-scm
    setuptools-rust
  ];

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytestCheckHook
  ];

  env = lib.optionalAttrs (!withCExtensions) {
    CBOR2_BUILD_C_EXTENSION = "0";
  };

  passthru = {
    inherit withCExtensions;
  };

  pythonImportsCheck = [ "cbor2" ];

  meta = {
    description = "Python CBOR (de)serializer with extensive tag support";
    changelog = "https://github.com/agronholm/cbor2/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/agronholm/cbor2";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "cbor2";

  };
})
