{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pycryptodomex
, pysnmp-pyasn1
, pysnmp-pysmi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysnmplib";
  version = "5.0.18";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysnmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-sruZWwvcpAACRPXAN+WKFsdOr9EXo4Ipu8H5I22iuRg=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysnmp-pysmi
    pysnmp-pyasn1
    pycryptodomex
  ];

  # Module has no test, examples are used for testing
  doCheck = false;

  pythonImportsCheck = [
    "pysnmp"
  ];

  meta = with lib; {
    description = "Implementation of v1/v2c/v3 SNMP engine";
    homepage = "https://github.com/pysnmp/pysnmp";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
