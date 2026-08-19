{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
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
  version = "2.0.0-unstable-2024-04-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "citation-file-format";
    repo = "cffconvert";
    rev = "b6045d78aac9e02b039703b030588d54d53262ac";
    hash = "sha256-zgH9q/Jj/AFoTqi9GJQognngIKtzPvYSWJWVsBdL6xg=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    changelog = "https://github.com/citation-file-format/cffconvert/blob/${src.rev}/CHANGELOG.md";
    description = "Command line program to validate and convert CITATION.cff files";
    homepage = "https://github.com/citation-file-format/cffconvert";
    license = lib.licenses.asl20;
    mainProgram = "cffconvert";
    maintainers = [ ];
  };
}
