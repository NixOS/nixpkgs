{
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
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Mako";
    inherit version;
    hash = "sha256-4WwB2aucEfcpDu8c/vwJP7WkXuSj2gni/sLk0brlTnM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ markupsafe ];

  passthru.optional-dependencies = {
    babel = [ babel ];
    lingua = [ lingua ];
  };

  nativeCheckInputs = [
    chameleon
    mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

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
