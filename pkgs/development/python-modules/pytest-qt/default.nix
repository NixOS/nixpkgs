{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pyqt5
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6ecf4b38088ae1092cbd5beeaf714516d1f81f8938626a2eac546206cdfe7fa";
  };

  buildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    pytest
    pyqt5
  ];

  # tests require X server
  doCheck = false;

  meta = with lib; {
    description = "pytest support for PyQt and PySide applications";
    homepage = http://github.com/pytest-dev/pytest-qt;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
