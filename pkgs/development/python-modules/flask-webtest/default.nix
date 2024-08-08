{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  webtest,
  blinker,
  flake8,
  twine,
  flask-sqlalchemy,
  greenlet,
}:

buildPythonPackage rec {
  pname = "flask-webtest";
  version = "0.1.4";
  pyproject = true;

  # Pypi tarball doesn't include version.py
  src = fetchFromGitHub {
    owner = "level12";
    repo = "flask-webtest";
    rev = version;
    hash = "sha256-4USNT6HYh49v+euCePYkL1gR6Ul8C0+/xanuYGxKpfM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    webtest
    blinker
  ];

  nativeCheckInputs = [
    flake8
    twine
    flask-sqlalchemy
    greenlet
  ];

  checkPhase = ''
    python3 setup.py sdist
    twine check dist/*
    flake8 flask_webtest.py tests
  '';

  pythonImportsCheck = [ "flask_webtest" ];

  meta = with lib; {
    description = "Utilities for testing Flask applications with WebTest";
    homepage = "https://github.com/level12/flask-webtest";
    changelog = "https://github.com/level12/flask-webtest/blob/master/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
