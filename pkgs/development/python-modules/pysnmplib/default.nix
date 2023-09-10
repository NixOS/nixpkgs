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
  version = "5.0.21";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysnmp";
    rev = "refs/tags/v${version}";
    hash = "sha256-ejRIlRxDbdZgy7wHilSzunRTGn1uO6YLLmLxNrrHKss=";
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
    changelog = "https://github.com/pysnmp/pysnmp/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
