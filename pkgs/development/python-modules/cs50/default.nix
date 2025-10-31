{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  packaging,
  setuptools,
  sqlalchemy,
  sqlparse,
  termcolor,
  wheel,
}:

buildPythonPackage rec {
  pname = "cs50";
  version = "9.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "python-cs50";
    tag = "v${version}";
    hash = "sha256-g7ws5ikzLt2ciS0QTPTJDRAqePyYPDCYIpJuwnWHJNQ=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    flask
    packaging
    sqlalchemy
    sqlparse
    termcolor
  ];

  # Tests require docker containers, which are pulled from the internet.
  pythonImportsCheck = [ "cs50" ];

  meta = {
    description = "CS50 Library for Python";
    homepage = "https://github.com/cs50/python-cs50/";
    changelog = "https://github.com/cs50/python-cs50/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      amadejkastelic
      ethancedwards8
    ];
  };
}
