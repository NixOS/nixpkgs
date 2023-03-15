{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "hstspreload";
  version = "2023.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-MF+pRP0KluF7LrSkfxs6ZSEXyqmr51mUqUn01dLdUdQ=";
  };

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [
    "hstspreload"
  ];

  meta = with lib; {
    description = "Chromium HSTS Preload list as a Python package and updated daily";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc SuperSandro2000 ];
  };
}
