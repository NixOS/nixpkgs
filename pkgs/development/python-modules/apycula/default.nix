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
  version = "0.13";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
    hash = "sha256-MXzF/nqJj+lsNjl3YLFHTqRLBVxBaKOY+GVboT6Pc4g=";
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
