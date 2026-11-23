{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ply,
  hatchling,
  requests,
}:

buildPythonPackage rec {
  pname = "pysnmp-pysmi";
  version = "6.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysmi";
    tag = "v${version}";
    hash = "sha256-U1WKc9xQISnDA85aUGXME5cOibpijSrlocf9UMjJY2E=";
  };

  build-system = [ hatchling ];

  dependencies = [
    ply
    requests
  ];

  pythonImportsCheck = [ "pysmi" ];

  meta = {
    description = "SNMP MIB parser";
    homepage = "https://github.com/pysnmp/pysmi";
    changelog = "https://github.com/pysnmp/pysmi/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
