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

buildPythonPackage (finalAttrs: {
  pname = "pytest-golden";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oprypin";
    repo = "pytest-golden";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E8H9HmTbWft5SDPUbuD9zRDRm7gHJsvWJfm9jznd1tY=";
  };

  pythonRelaxDeps = [ "testfixtures" ];

  build-system = [ hatchling ];

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
})
