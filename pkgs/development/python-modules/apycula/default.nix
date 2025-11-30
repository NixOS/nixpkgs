{
  lib,
  buildPythonPackage,
  crc,
  fetchPypi,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "apycula";
  version = "0.28";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AfNjHQkDrZ9oULuEmgXhqr063NWDZCpVW5pE6chnnFI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ crc ];

  # Tests require a physical FPGA
  doCheck = false;

  pythonImportsCheck = [ "apycula" ];

  meta = with lib; {
    description = "Open Source tools for Gowin FPGAs";
    homepage = "https://github.com/YosysHQ/apicula";
    changelog = "https://github.com/YosysHQ/apicula/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
