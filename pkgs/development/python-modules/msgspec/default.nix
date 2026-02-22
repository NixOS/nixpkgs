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
  pyyaml,
  setuptools,
  sphinx,
  sphinx-copybutton,
  sphinx-design,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = "msgspec";
    tag = version;
    # Note that this hash changes after some time after release because they
    # use `$Format:%d$` in msgspec/_version.py, and GitHub produces different
    # tarballs depending on whether tagged commit is the last commit, see
    # https://github.com/NixOS/nixpkgs/issues/84312
    hash = "sha256-CajdPNAkssriY/sie5gR+4k31b3Wd7WzqcsFmrlSoPY=";
  };

  build-system = [ setuptools ];

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

  # Requires libasan to be accessible
  doCheck = false;

  pythonImportsCheck = [ "msgspec" ];

  meta = {
    description = "Module to handle JSON/MessagePack";
    homepage = "https://github.com/jcrist/msgspec";
    changelog = "https://github.com/jcrist/msgspec/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
