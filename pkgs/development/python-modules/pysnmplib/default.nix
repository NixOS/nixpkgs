{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pycryptodomex,
  pysnmp-pyasn1,
  pysnmp-pysmi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysnmplib";
  version = "5.0.24";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pysnmp";
    repo = "pysnmp";
    tag = "v${version}";
    hash = "sha256-AtQqXiy943cYhHDsyz9Yk5uA4xK7Q4p21CT3X3zYzrQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    pysnmp-pysmi
    pysnmp-pyasn1
    pycryptodomex
  ];

  # Module has no test, examples are used for testing
  doCheck = false;

  pythonImportsCheck = [ "pysnmp" ];

  meta = with lib; {
    description = "Implementation of v1/v2c/v3 SNMP engine";
    homepage = "https://github.com/pysnmp/pysnmp";
    changelog = "https://github.com/pysnmp/pysnmp/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
