{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  msgpack,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  ruamel-yaml,
  setuptools,
  toml,
  tomli,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "python-box";
  version = "7.3.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    tag = version;
    hash = "sha256-aVPjIoizqC0OcG5ziy/lvp/JsFSUvcLUqJ03mKViKFs=";
  };

  build-system = [
    cython
    setuptools
  ];

  optional-dependencies = {
    all = [
      msgpack
      ruamel-yaml
      toml
    ];
    yaml = [ ruamel-yaml ];
    ruamel-yaml = [ ruamel-yaml ];
    PyYAML = [ pyyaml ];
    tomli = [ tomli-w ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];
    toml = [ toml ];
    msgpack = [ msgpack ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  disabledTests = [
    # ruamel 8.18.13 update changed white space rules
    "test_to_yaml_ruamel"
  ];

  pythonImportsCheck = [ "box" ];

  meta = with lib; {
    description = "Python dictionaries with advanced dot notation access";
    homepage = "https://github.com/cdgriffith/Box";
    changelog = "https://github.com/cdgriffith/Box/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
