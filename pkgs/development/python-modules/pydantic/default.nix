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
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.5.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fwrx7p6d5vskg9ibganahiz9y9299idvdmzhjw62jy84gn1vrb4";
  };

  propagatedBuildInputs = [
    ujson
    email_validator
    typing-extensions
  ];

  checkInputs = [
    pytest
    pytestcov
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
