{ lib, fetchPypi, buildPythonPackage, packaging, sip }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.12.2";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    sha256 = "f62bb688d70e0afd88c413a8d994bda824e6cebd12b612902d1945c5a67edcd7";
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
