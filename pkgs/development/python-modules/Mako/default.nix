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
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "169fa52af22a91900d852e937400e79f535496191c63712e3b9fda5a9bed6fc3";
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
