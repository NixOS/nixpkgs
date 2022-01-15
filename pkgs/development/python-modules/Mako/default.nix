{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, markupsafe
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Mako";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e9e345a41924a954251b95b4b28e14a301145b544901332e658907a7464b6b2";
  };

  propagatedBuildInputs = [ markupsafe ];
  checkInputs = [ pytestCheckHook markupsafe mock ];

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
