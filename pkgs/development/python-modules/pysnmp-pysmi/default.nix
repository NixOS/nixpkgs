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
  version = "1.1.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysmi";
    rev = "refs/tags/v${version}";
    hash = "sha256-qe99nLOyUvE6LJagtQ9whPF4zwIWiM7g5zn40QsmrmA=";
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
    changelog = "https://github.com/pysnmp/pysmi/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
