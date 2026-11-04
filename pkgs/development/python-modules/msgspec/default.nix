{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  coverage,
  furo,
  ipython,
  msgpack,
  mypy,
  pre-commit,
  pyright,
  pytest,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  sphinx,
  sphinx-copybutton,
  sphinx-design,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "msgspec";
    repo = "msgspec";
    tag = version;
    # Note that this hash changes after some time after release because they
    # use `$Format:%d$` in msgspec/_version.py, and GitHub produces different
    # tarballs depending on whether tagged commit is the last commit, see
    # https://github.com/NixOS/nixpkgs/issues/84312
    hash = "sha256-ZCimTcAcFLWtmX0c8AqlkFD8KEgciHoNH63qvwArzak=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies = {
    dev = [
      coverage
      mypy
      pre-commit
      pyright
    ]
    ++ optional-dependencies.doc
    ++ optional-dependencies.test;
    doc = [
      furo
      ipython
      sphinx
      sphinx-copybutton
      sphinx-design
    ];
    test = [
      attrs
      msgpack
      pytest
    ]
    ++ optional-dependencies.yaml
    ++ optional-dependencies.toml;
    toml = [ tomli-w ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # `tests/typing` runs type checkers
  enabledTestPaths = [ "tests/unit" ];

  pythonImportsCheck = [ "msgspec" ];

  meta = {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/msgspec/msgspec";
    changelog = "https://github.com/msgspec/msgspec/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
