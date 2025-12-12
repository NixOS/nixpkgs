{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  setuptools-scm,
  sphinx,
  sphinx-copybutton,
  sphinx-design,
  tomli,
  tomli-w,
}:

buildPythonPackage rec {
  pname = "msgspec";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jcrist";
    repo = "msgspec";
    tag = version;
    hash = "sha256-DWDmnSuo12oXl9NVfNhIOtWrQeJ9DMmHxOyHY33Datk=";
  };

  build-system = [ setuptools-scm ];

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
    toml = [
      tomli-w
    ]
    ++ lib.optional (pythonOlder "3.11") tomli;
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
