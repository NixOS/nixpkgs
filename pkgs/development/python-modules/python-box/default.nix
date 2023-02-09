{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
  version = "7.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cdgriffith";
    repo = "Box";
    rev = "refs/tags/${version}";
    hash = "sha256-CvcVN5DTaT8mSf2FtFrt7DHP+YLbVI15/5Vjfmgae34=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/cdgriffith/Box/pull/247
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/cdgriffith/Box/commit/a43b98c5f5ff1074568dcef27cf17e7065d1019c.patch";
      hash = "sha256-ul/MVSzgjN3D+Vuzn7YPITaDrtS58vDmA23hy1EVF9U=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
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
