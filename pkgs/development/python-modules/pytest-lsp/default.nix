{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  pygls_2,
  pytestCheckHook,
  pytest-asyncio,
  packaging,
}:

buildPythonPackage rec {
  pname = "pytest-lsp";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pytest_lsp";
    hash = "sha256-uoyVstl1o2Akn/pXaOHm9E2H0Q73dUBw07MhECckovE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pygls_2
    pytest-asyncio
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_lsp" ];

  meta = {
    homepage = "https://github.com/swyddfa/lsp-devtools";
    changelog = "https://github.com/swyddfa/lsp-devtools/blob/develop/lib/pytest-lsp/CHANGES.md";
    description = "Pytest plugin for writing end-to-end tests for language servers";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      clemjvdm
      fliegendewurst
    ];
  };
}
