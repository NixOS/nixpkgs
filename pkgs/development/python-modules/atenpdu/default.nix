{
  lib,
  buildPythonPackage,
  fetchPypi,
  async-timeout,
  pysnmp-lextudio,
  pythonOlder,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "atenpdu";
  version = "0.6.2";
  pyproject = true;

  disabled = pythonOlder "3.";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KzRoE4tE/tQkKYroq5PbWKREmEl8AwbIOg3IHRZZtsQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    async-timeout
    pysnmp-lextudio
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "atenpdu" ];

  meta = with lib; {
    description = "Python interface to control ATEN PE PDUs";
    mainProgram = "pductl";
    homepage = "https://github.com/mtdcr/pductl";
    changelog = "https://github.com/mtdcr/pductl/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
