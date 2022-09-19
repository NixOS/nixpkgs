{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, build
, git
, importlib-metadata
, pep517
, pytest-mock
, pytestCheckHook
, setuptools
, tomlkit
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "sha256-WUgBrO9h1E7N2SVFD47UPv39DMx1yQviV5tcNPmR+/g=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    build
    git
    pep517
    pytest-mock
    pytestCheckHook
    setuptools
    tomlkit
    virtualenv
  ];

  # requires git history to work correctly
  disabledTests = [ "default_with_excluded_data" "default_src_with_excluded_data" ];

  pythonImportsCheck = [ "poetry.core" ];

  # allow for package to use pep420's native namespaces
  pythonNamespaces = [ "poetry" ];

  meta = with lib; {
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
