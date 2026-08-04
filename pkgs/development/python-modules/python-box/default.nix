{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  msgpack,
  pytestCheckHook,
  pyyaml,
  ruamel-yaml,
  setuptools,
  toml,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "python-box";
  version = "7.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    tag = version;
    hash = "sha256-tzkTiuH9zBUFYXda6iv4Ohh72WBVcW/BykMS5W7BPPo=";
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
    tomli = [ tomli-w ];
    toml = [ toml ];
    msgpack = [ msgpack ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  disabledTests = [
    # ruamel 8.18.13 update changed white space rules
    "test_to_yaml_ruamel"
    # Optional toon_format encoder is not packaged
    "test_toon_strings"
    "test_toon_files"
    "test_toon_from_toon_with_box_args"
  ];

  pythonImportsCheck = [ "box" ];

  meta = {
    description = "Python dictionaries with advanced dot notation access";
    homepage = "https://github.com/cdgriffith/Box";
    changelog = "https://github.com/cdgriffith/Box/blob/${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
