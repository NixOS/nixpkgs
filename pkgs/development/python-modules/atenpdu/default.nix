{
  lib,
  buildPythonPackage,
  fetchPypi,
  async-timeout,
  pysnmp,
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail pysnmp-lextudio pysnmp
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    async-timeout
    pysnmp
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
