{
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  lib,
  libyaml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyyaml-ft";
  version = "8.0.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Quansight-Labs";
    repo = "pyyaml-ft";
    tag = "v${version}";
    hash = "sha256-GiXYpcAccKgROw144eOPY0gS0xW+3K/jRUl+JnBEaO8=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ libyaml ];

  pythonImportsCheck = [ "yaml_ft" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/Quansight-Labs/pyyaml-ft/blob/${src.tag}/CHANGES";
    description = "YAML parser and emitter for Python with support for free-threading";
    homepage = "https://github.com/Quansight-Labs/pyyaml-ft";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
