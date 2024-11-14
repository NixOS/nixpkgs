{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
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
  version = "1.3.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Mako";
    inherit version;
    hash = "sha256-SNvCBWjB0naiaYs22Wj6dhYb8ScZSQfqb8WU+oH5Q7w=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ markupsafe ];

  optional-dependencies = {
    babel = [ babel ];
    lingua = [ lingua ];
  };

  nativeCheckInputs = [
    chameleon
    mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests =
    lib.optionals isPyPy [
      # https://github.com/sqlalchemy/mako/issues/315
      "test_alternating_file_names"
      # https://github.com/sqlalchemy/mako/issues/238
      "test_file_success"
      "test_stdin_success"
      # fails on pypy2.7
      "test_bytestring_passthru"
    ]
    # https://github.com/sqlalchemy/mako/issues/408
    ++ lib.optional (stdenv.targetPlatform.useLLVM or false) "test_future_import";

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
