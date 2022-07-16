{ lib, fetchPypi, buildPythonPackage, packaging, sip }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.13.0";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    sha256 = "sha256-SHdYDDjOtTIOEps4HQg7CoYBxoFm2LmXB/CPoKFonu8=";
  };

  propagatedBuildInputs = [ packaging sip ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = with lib; {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://pypi.org/project/PyQt-builder/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
