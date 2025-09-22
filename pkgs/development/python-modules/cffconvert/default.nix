{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  requests,
  ruamel-yaml,
  pykwalify,
  jsonschema,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "cffconvert";
  version = "2.0.0-unstable-2024-02-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "citation-file-format";
    repo = "cffconvert";
    rev = "5295f87c0e261da61a7b919fc754e3a77edd98a7";
    hash = "sha256-/2qhWVNylrqPSf1KmuZQahzq+YH860cohVSfJsDm1BE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    requests
    ruamel-yaml
    pykwalify
    jsonschema
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTestPaths = [
    # requires network access
    "tests/cli/test_rawify_url.py"
  ];

  pythonImportsCheck = [ "cffconvert" ];

  meta = {
    changelog = "https://github.com/citation-file-format/cffconvert/blob/${src.rev}/CHANGELOG.md";
    description = "Command line program to validate and convert CITATION.cff files";
    homepage = "https://github.com/citation-file-format/cffconvert";
    license = lib.licenses.asl20;
    mainProgram = "cffconvert";
    maintainers = with lib.maintainers; [ ];
  };
}
