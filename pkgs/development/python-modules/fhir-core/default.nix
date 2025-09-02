{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pyyaml,
  setuptools,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "fhir-core";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nazrulworld";
    repo = "fhir-core";
    tag = version;
    hash = "sha256-5FA/G68O5d1ebGE3xJ0ThN6CNTwh2AA44NuOkW2Z4lA=";
  };

  # pytest-runner was removed from Nixpkgs
  postPatch = ''
    substituteInPlace setup.py --replace-fail '["pytest-runner"]' '[]'
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    pydantic
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
  ];

  pythonImportsCheck = [
    "fhir_core"
  ];

  meta = {
    description = "Core library for FHIR using Pydantic";
    homepage = "https://github.com/nazrulworld/fhir-core";
    changelog = "https://github.com/nazrulworld/fhir-core/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
