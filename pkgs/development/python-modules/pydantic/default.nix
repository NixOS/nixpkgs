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
  version = "1.3";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s85nzlsyj97j54zsgv569hkzv617z0vqsifsxkkyiimgbvnx7g8";
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
