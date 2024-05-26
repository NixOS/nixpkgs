{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blinker,
  flit-core,
  flask,
}:

buildPythonPackage rec {
  pname = "flask-mail";
  version = "0.10.0";
  meta = {
    description = "Flask-Mail is a Flask extension providing simple email sending capabilities.";
    homepage = "https://pypi.python.org/pypi/Flask-Mail";
    license = lib.licenses.bsd3;
  };
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-mail";
    rev = "refs/tags/${version}";
    hash = "sha256-G2Z8dj1/IuLsZoNJVrL6LYu0XjTEHtWB9Z058aqG9Ic=";
  };

  build-system = [ flit-core ];

  dependencies = [
    blinker
    flask
  ];

  doCheck = false;
}
