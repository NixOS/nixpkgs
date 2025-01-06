{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  bcrypt,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-bcrypt";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = pname;
    rev = version;
    hash = "sha256-WlIholi/nzq6Ikc0LS6FhG0Q5Kz0kvvAlA2YJ7EksZ4=";
  };

  propagatedBuildInputs = [
    flask
    bcrypt
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "flask_bcrypt" ];

  meta = {
    description = "Brcrypt hashing for Flask";
    homepage = "https://github.com/maxcountryman/flask-bcrypt";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
