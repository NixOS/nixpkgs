{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, isPyPy

# propagates
, markupsafe

# extras: Babel
, babel

# tests
, mock
, pytestCheckHook
, lingua
, chameleon
}:

buildPythonPackage rec {
  pname = "Mako";
  version = "1.2.4";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1go5A9w7sBoYrWqJzb4uTq3GnAvI7x43c7pT1Ew/ejQ=";
  };

  propagatedBuildInputs = [
    markupsafe
  ];

  passthru.optional-dependencies = {
    babel = [
      babel
    ];
  };

  checkInputs = [
    chameleon
    lingua
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.babel;

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
    homepage = "https://www.makotemplates.org/";
    changelog = "https://docs.makotemplates.org/en/latest/changelog.html";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
  };
}
