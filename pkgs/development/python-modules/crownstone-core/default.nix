{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyaes,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "crownstone-core";
  version = "3.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crownstone";
    repo = "crownstone-lib-python-core";
    tag = finalAttrs.version;
    hash = "sha256-zrlCzx7N3aUcTUNa64jSzDdWgQneX+Hc5n8TTTcZ4ck=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyaes ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "crownstone_core" ];

  meta = {
    description = "Python module with shared classes, util functions and definition of Crownstone";
    homepage = "https://github.com/crownstone/crownstone-lib-python-core";
    changelog = "https://github.com/crownstone/crownstone-lib-python-core/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
