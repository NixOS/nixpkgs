{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  html-table-parser-python3,
  requests,
}:

buildPythonPackage rec {
  pname = "bthomehub5-devicelist";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bWMwLbFGdMRcZLIVbOptWMOOFzVBm2KxQ9jwqvAU6zA=";
  };

  pythonRelaxDeps = [ "html-table-parser-python3" ];

  build-system = [ setuptools ];

  dependencies = [
    html-table-parser-python3
    requests
  ];

  # No tests in the package
  doCheck = false;

  pythonImportsCheck = [ "bthomehub5_devicelist" ];

  meta = {
    description = "Returns a list of devices currently connected to a BT Home Hub 5";
    homepage = "https://github.com/ahobsonsayers/bthomehub5-devicelist";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
