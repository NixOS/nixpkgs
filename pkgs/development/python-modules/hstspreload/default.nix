{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2024.2.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "hstspreload";
    rev = "refs/tags/${version}";
    hash = "sha256-e0PQpnzYWl8IMtLFdnYPMCBioriumc3vc1ExRjCYoc8=";
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
