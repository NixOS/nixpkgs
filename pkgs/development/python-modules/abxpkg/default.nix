{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  platformdirs,
  pydantic,
  rich-click,
  typing-extensions,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "abxpkg";
  version = "1.13.35";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sKGlEx/l4Nmgt86yhD0vykfQmS3Jd52tY9UUBLMtaJE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
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
