{ lib
, buildPythonPackage
<<<<<<< HEAD
, cython_3
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "7.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "7.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-oxT2y3um6BZ3bwYa+LWBoTgU+9b+V7XtQdCdECU3Gu0=";
  };

  nativeBuildInputs = [
    cython_3
=======
    hash = "sha256-Ddt8/S6HzmOt1kvzRzed3+TbOacw6RG9nd2UNn+ELB4=";
  };

  nativeBuildInputs = [
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
