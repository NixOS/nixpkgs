{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  webtest,
  blinker,
  flask-sqlalchemy,
  greenlet,
}:

buildPythonPackage rec {
  pname = "flask-webtest";
  version = "0.1.6";
  pyproject = true;

  # Pypi tarball doesn't include version.py
  src = fetchFromGitHub {
    owner = "level12";
    repo = "flask-webtest";
    tag = version;
    hash = "sha256-wcEc9j62bQXAmXczsunITQP3sU040d6Ws8cz0w7+5r4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    webtest
    blinker
  ];

  nativeCheckInputs = [
    flask-sqlalchemy
    greenlet
  ];

  pythonImportsCheck = [ "flask_webtest" ];

  meta = with lib; {
    description = "Utilities for testing Flask applications with WebTest";
    homepage = "https://github.com/level12/flask-webtest";
    changelog = "https://github.com/level12/flask-webtest/blob/${src.rev}/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
