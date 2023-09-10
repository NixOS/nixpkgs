{ lib
, buildPythonPackage
, fetchPypi
, packaging
, setuptools
, sip
, wheel
}:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.15.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    hash = "sha256-dGz+g8A+v/RFjUeKHAZxR5Dvk+RY7NWii8KDe6yI63Q=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

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
