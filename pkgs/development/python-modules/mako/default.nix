{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,
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
  version = "1.3.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sqlalchemy";
    repo = "mako";
    tag = "rel_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-7KttExqHxv//q8ol7eOFIrgRHbQySQTvL7Rd9VooX0Y=";
  };

  patches = [
    (fetchpatch {
      name = "float-precision.patch";
      url = "https://github.com/sqlalchemy/mako/commit/188d5431a5c93b937da03e70c4c2c8c42cd9a502.patch";
      hash = "sha256-/ROS6WkSqYXJsX6o1AejUg/faS3lUAimrRJzS74Bwws=";
    })
  ];

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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = lib.optionals isPyPy [
    # https://github.com/sqlalchemy/mako/issues/315
    "test_alternating_file_names"
    # https://github.com/sqlalchemy/mako/issues/238
    "test_file_success"
    "test_stdin_success"
    # fails on pypy2.7
    "test_bytestring_passthru"
  ];

  meta = with lib; {
    description = "Super-fast templating language";
    mainProgram = "mako-render";
    homepage = "https://www.makotemplates.org/";
    changelog = "https://docs.makotemplates.org/en/latest/changelog.html";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
  };
}
