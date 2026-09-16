{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pip,
  platformdirs,
  pydantic,
  rich-click,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "abxpkg";
  version = "1.10.31";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-vFEtSqZtDgLQZOHYvSQsyIWsvWhBtpBiwTcBrfvg4JQ=";
  };

  pythonRelaxDeps = [ "pip" ];

  build-system = [
    hatchling
  ];

  dependencies = [
    pip
    platformdirs
    pydantic
    rich-click
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests invoke package manager CLIs (apt, brew, npm) not available in the sandbox
  doCheck = false;

  pythonImportsCheck = [ "abxpkg" ];

  meta = {
    changelog = "https://github.com/ArchiveBox/abxpkg/releases";
    description = "Modern Python library for detecting and managing system dependencies via apt, brew, pip, and npm";
    homepage = "https://github.com/ArchiveBox/abxpkg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
