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
  version = "1.4";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zmnwyvvrj6nb2r1wh63yb6dzqaxw8m4njzqycjdq9911c5gwg6z";
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
