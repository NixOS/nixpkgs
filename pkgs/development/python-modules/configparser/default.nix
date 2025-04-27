{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "configparser";
  version = "7.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "configparser";
    tag = "v${version}";
    hash = "sha256-ZPoHnmD0YjY3+dUW1NKDJjNOVrUFNOjQyMqamOsS2RQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Updated configparser from Python 3.7 for Python 2.6+";
    homepage = "https://github.com/jaraco/configparser";
    license = licenses.mit;
    maintainers = [ ];
  };
}
