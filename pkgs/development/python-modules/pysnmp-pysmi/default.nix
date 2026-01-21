{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ply,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "pysnmp-pysmi";
  version = "1.1.12";
  pyproject = true;

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

  meta = {
    description = "SNMP MIB parser";
    homepage = "https://github.com/pysnmp/pysmi";
    changelog = "https://github.com/pysnmp/pysmi/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
