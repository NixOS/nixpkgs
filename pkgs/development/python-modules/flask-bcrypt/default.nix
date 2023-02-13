{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, bcrypt
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "flask-bcrypt";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = pname;
    rev = version;
    sha256 = "sha256-WlIholi/nzq6Ikc0LS6FhG0Q5Kz0kvvAlA2YJ7EksZ4=";
  };

  propagatedBuildInputs = [
    flask
    bcrypt
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [
    "flask_bcrypt"
  ];

  meta = with lib; {
    description = "Brcrypt hashing for Flask";
    homepage = "https://github.com/maxcountryman/flask-bcrypt";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
