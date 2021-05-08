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
  version = "1.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17831f0b7087c313c0ffae2bcbbd3c1d5ba9eeac9c38f2eb7b50e8c99fe9d5ab";
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
