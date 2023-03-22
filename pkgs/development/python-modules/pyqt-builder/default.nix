{ lib, fetchPypi, buildPythonPackage, packaging, sip }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.14.1";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    hash = "sha256-g7w+MAr/i0FAWAS2qcKRM4mrWcSK2fDLhYSm73O8pQI=";
  };

  propagatedBuildInputs = [ packaging sip ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = with lib; {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://pypi.org/project/PyQt-builder/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
