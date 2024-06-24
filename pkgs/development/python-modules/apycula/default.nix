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
  version = "0.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
    hash = "sha256-aF/JVm4d6c631y+RdsCk3pAVSroRBY+lW2wBRvgcQH8=";
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
