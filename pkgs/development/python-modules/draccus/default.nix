{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  mergedeep,
  pyyaml,
  pyyaml-include,
  toml,
  typing-inspect,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "draccus";
  version = "0.11.5";
  pyproject = true;

  # No (recent) tags on GitHub
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uC4sICcDCuGg8QVRUSX5FOBQwHZqtRjfOgVgoH0Q3ck=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mergedeep
    pyyaml
    pyyaml-include
    toml
    typing-inspect
  ];

  pythonImportsCheck = [ "draccus" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Framework for simple dataclass-based configurations based on Pyrallis";
    homepage = "https://github.com/dlwh/draccus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
