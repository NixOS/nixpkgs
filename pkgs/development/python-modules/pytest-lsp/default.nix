{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  pygls,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pytest-lsp";
  version = "0.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pytest_lsp";
    hash = "sha256-ND9r2i+qMg7V/Ld8lCDScDzlZdHRRP6CfjGYp9wpkRw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pygls
    pytest-asyncio
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
