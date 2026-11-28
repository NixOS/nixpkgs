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
  toon-format,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-box";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    tag = finalAttrs.version;
    hash = "sha256-7/yr4nQHd2SqH8tNoOWbss0weDNPYk5b1XkqjdskDYQ=";
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

  nativeCheckInputs = [
    pytestCheckHook
    toon-format
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  disabledTests = [
    # ruamel 8.18.13 update changed white space rules
    "test_to_yaml_ruamel"
  ];

  pythonImportsCheck = [ "box" ];

  meta = {
    description = "Python dictionaries with advanced dot notation access";
    homepage = "https://github.com/cdgriffith/Box";
    changelog = "https://github.com/cdgriffith/Box/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
