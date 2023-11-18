{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, ply
, poetry-core
, requests
}:

buildPythonPackage rec {
  pname = "pysnmp-pysmi";
  version = "1.1.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysmi";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZfN0nU9IurBEjSZijC2E4UoLIM54mBFgv7rcI1v/a4Q=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    ply
    requests
  ];

  # Circular dependency with pysnmplib
  doCheck = false;

  pythonImportsCheck = [
    "pysmi"
  ];

  meta = with lib; {
    description = "SNMP MIB parser";
    homepage = "https://github.com/pysnmp/pysmi";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
