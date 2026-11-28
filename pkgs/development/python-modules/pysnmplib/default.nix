{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pycryptodomex,
  pysnmp-pyasn1,
  pysnmp-pysmi,
}:

buildPythonPackage rec {
  pname = "pysnmplib";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysnmp";
    tag = "v${version}";
    hash = "sha256-mF+fHDJ1xkFKDB0DOJHh501xTlrAzC52BzSSJ+edVTc=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    pysnmp-pysmi
    pysnmp-pyasn1
    pycryptodomex
  ];

  # Module has no test, examples are used for testing
  doCheck = false;

  pythonImportsCheck = [ "pysnmp" ];

  meta = {
    description = "Implementation of v1/v2c/v3 SNMP engine";
    homepage = "https://github.com/pysnmp/pysnmp";
    changelog = "https://github.com/pysnmp/pysnmp/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
