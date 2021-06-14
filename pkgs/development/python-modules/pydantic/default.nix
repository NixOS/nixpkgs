{ lib
, buildPythonPackage
, email_validator
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, python-dotenv
, pythonOlder
, typing-extensions
, ujson
}:

buildPythonPackage rec {
  pname = "pydantic";
  version = "1.8.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "samuelcolvin";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zvcmx3927fgx37gdhi8g8igvrkri1v78rn3118p4wssqhgfwa6n";
  };

  propagatedBuildInputs = [
    email_validator
    python-dotenv
    typing-extensions
    ujson
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "pydantic" ];

  meta = with lib; {
    homepage = "https://github.com/samuelcolvin/pydantic";
    description = "Data validation and settings management using Python type hinting";
    license = licenses.mit;
    maintainers = with maintainers; [ wd15 ];
  };
}
