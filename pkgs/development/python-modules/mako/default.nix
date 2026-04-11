{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPyPy,

  # build-system
  setuptools,

  # propagates
  markupsafe,

  # optional-dependencies
  babel,
  lingua,

  # tests
  chameleon,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mako";
  version = "1.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "mako";
    tag = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-lxGlYyKbrDpr2LHcsqTow+s2l8+g+63M5j8xJt++tGo=";
  };

  build-system = [ setuptools ];

  dependencies = [ markupsafe ];

  optional-dependencies = {
    babel = [ babel ];
    lingua = [ lingua ];
  };

  nativeCheckInputs = [
    chameleon
    mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = lib.optionals isPyPy [
    # https://github.com/sqlalchemy/mako/issues/315
    "test_alternating_file_names"
    # https://github.com/sqlalchemy/mako/issues/238
    "test_file_success"
    "test_stdin_success"
    # fails on pypy2.7
    "test_bytestring_passthru"
  ];

  meta = {
    description = "Super-fast templating language";
    mainProgram = "mako-render";
    homepage = "https://www.makotemplates.org/";
    changelog = "https://docs.makotemplates.org/en/latest/changelog.html";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
