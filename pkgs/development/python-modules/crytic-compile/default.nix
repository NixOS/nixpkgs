{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pysha3
, setuptools
}:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    rev = "refs/tags/${version}";
    hash = "sha256-phb4Y8CUxuHsNt43oKsgDAZTraNauPkcYQtzcsiWyy8=";
  };

  propagatedBuildInputs = [
    pysha3
    setuptools
  ];

  doCheck = false;

  pythonImportsCheck = [
    "crytic_compile"
  ];

  meta = with lib; {
    description = "Abstraction layer for smart contract build systems";
    homepage = "https://github.com/crytic/crytic-compile";
    changelog = "https://github.com/crytic/crytic-compile/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 arturcygan ];
  };
}
