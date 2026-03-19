{
  lib,
  atomicwrites,
  buildPythonPackage,
  fetchFromGitHub,
  ruamel-yaml,
  hatchling,
  pytest,
  pytestCheckHook,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "pytest-golden";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "pytest-golden";
    tag = "v${version}";
    hash = "sha256-mjb8lBAoZxwUCN4AIMK/n70aC41Y4IV/+hrW11S9rcw=";
  };

  pythonRelaxDeps = [ "testfixtures" ];

  build-system = [
    hatchling
  ];

  buildInputs = [ pytest ];

  dependencies = [
    atomicwrites
    ruamel-yaml
    testfixtures
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_golden" ];

  meta = {
    description = "Plugin for pytest that offloads expected outputs to data files";
    homepage = "https://github.com/oprypin/pytest-golden";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
