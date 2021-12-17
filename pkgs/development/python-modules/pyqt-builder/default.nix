{ lib, fetchPypi, buildPythonPackage, packaging, sip }:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.10.1";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    sha256 = "05vyckg4pq95s3b23drhd24sjwzic1k36nwckxz5jc83mixhqywn";
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
