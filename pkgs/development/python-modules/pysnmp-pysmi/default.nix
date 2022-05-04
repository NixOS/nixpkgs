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
  version = "1.1.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysmi";
    rev = "v${version}";
    hash = "sha256-nsIEZPD7bfbePZukkudP0ZH/m8Be88QkVDM5PdjNHVk=";
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
