{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2024.3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "hstspreload";
    rev = "refs/tags/${version}";
    hash = "sha256-TlPZg1IbgOODbkgJHWI6dNdk3jsyL2L/3qhLtXvQjqI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [
    "hstspreload"
  ];

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
