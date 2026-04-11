{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  impacket,
  lxml,
  poetry-core,
  pyasn1,
}:

buildPythonPackage rec {
  pname = "dploot";
  version = "3.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xCw4mAP9CUtcTeQQ//4zI0BcQUmTai9hvYSZ9F9k4rc=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "lxml"
    "pyasn1"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    impacket
    cryptography
    pyasn1
    lxml
  ];

  pythonImportsCheck = [ "dploot" ];

  # No tests
  doCheck = false;

  meta = {
    description = "DPAPI looting remotely in Python";
    homepage = "https://github.com/zblurx/dploot";
    changelog = "https://github.com/zblurx/dploot/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vncsb ];
    mainProgram = "dploot";
  };
}
