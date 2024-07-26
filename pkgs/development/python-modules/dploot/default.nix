{
  lib,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  impacket,
  lxml,
  poetry-core,
  pyasn1,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dploot";
  version = "2.7.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YlRXUSCzVRXxRQcmPzTeyPQ3zK+UlhO9BmZVx6qVRpc=";
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

  meta = with lib; {
    description = "DPAPI looting remotely in Python";
    homepage = "https://github.com/zblurx/dploot";
    changelog = "https://github.com/zblurx/dploot/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ vncsb ];
    mainProgram = "dploot";
  };
}
