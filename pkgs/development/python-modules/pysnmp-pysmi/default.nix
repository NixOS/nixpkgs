{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  ply,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "pysnmp-pysmi";
  version = "1.1.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysmi";
    tag = "v${version}";
    hash = "sha256-dK02y8HXhwq1W6NOYsycjTpIMxoQY4qNT4n8TEycmWM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    ply
    requests
  ];

  # Circular dependency with pysnmplib
  doCheck = false;

  pythonImportsCheck = [ "pysmi" ];

  meta = with lib; {
    description = "SNMP MIB parser";
    homepage = "https://github.com/pysnmp/pysmi";
    changelog = "https://github.com/pysnmp/pysmi/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
