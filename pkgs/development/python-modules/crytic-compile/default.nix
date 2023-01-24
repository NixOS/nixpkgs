{ lib
, buildPythonPackage
, cbor2
, fetchFromGitHub
, pycryptodome
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "crytic-compile";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "crytic-compile";
    rev = "refs/tags/${version}";
    hash = "sha256-4iTvtu2TmxvLTyWm4PV0+yV1fRLYpJHZNBgjy1MFLjM=";
  };

  propagatedBuildInputs = [
    cbor2
    pycryptodome
    setuptools
  ];

  # Test require network access
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
