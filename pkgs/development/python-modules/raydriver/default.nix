{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustc,
  rustPlatform,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "raydriver";
  version = "0.5.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-HtZnv6TISG1OaK9+K69I+f/RqOemagozVzWLjB21yMc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-W5Oj+tpr2fSUtb1vGPl/ZMvSJENG21NEtCCRdr2I+vE=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "raydriver" ];

  meta = {
    description = "Rust-native machine drivers for Rayforge, with Python bindings";
    homepage = "https://github.com/barebaric/raydriver";
    license = lib.licenses.mit;
    mainProgram = "raydriver";
    maintainers = with lib.maintainers; [ kanagawamarcos ];
  };
})
