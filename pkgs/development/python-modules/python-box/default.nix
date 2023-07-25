{ lib
, buildPythonPackage
, fetchFromGitHub
, msgpack
, poetry-core
, pytestCheckHook
, pythonOlder
, pyyaml
, ruamel-yaml
, setuptools
, toml
, tomli
, tomli-w
}:

buildPythonPackage rec {
  pname = "python-box";
  version = "7.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    rev = "refs/tags/${version}";
    hash = "sha256-Ddt8/S6HzmOt1kvzRzed3+TbOacw6RG9nd2UNn+ELB4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
    all = [
      msgpack
      ruamel-yaml
      toml
    ];
    yaml = [
      ruamel-yaml
    ];
    ruamel-yaml = [
      ruamel-yaml
    ];
    PyYAML = [
      pyyaml
    ];
    tomli = [
      tomli-w
    ] ++ lib.optionals (pythonOlder "3.11") [
      tomli
    ];
    toml = [
      toml
    ];
    msgpack = [
      msgpack
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  pythonImportsCheck = [
    "box"
  ];

  meta = with lib; {
    description = "Python dictionaries with advanced dot notation access";
    homepage = "https://github.com/cdgriffith/Box";
    changelog = "https://github.com/cdgriffith/Box/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
