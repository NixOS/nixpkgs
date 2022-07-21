{ lib, fetchPypi, buildPythonPackage, packaging, sip }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.13.0";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    sha256 = "sha256-SHdYDDjOtTIOEps4HQg7CoYBxoFm2LmXB/CPoKFonu8=";
  };

  patches = [
    # use the sip-distinfo executable from PATH instead of trying to guess,
    # we know it's the right one because it's the _only_ one
    ./use-sip-distinfo-from-path.patch
  ];

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
