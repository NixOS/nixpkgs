{ lib
, buildPythonPackage
, fetchFromGitHub
, ujson
, email_validator
, typing-extensions
, python
, isPy3k
, pytest
, pytestcov
, pytest-mock
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.7.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "xihEDmly0vprmA+VdeCoGXg9PjWRPmBWAwk/9f2DLts=";
  };

  propagatedBuildInputs = [
    ujson
    email_validator
    typing-extensions
  ];

  checkInputs = [
    pytest
    pytestcov
    pytest-mock
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/samuelcolvin/pydantic";
    description = "Data validation and settings management using Python type hinting";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
