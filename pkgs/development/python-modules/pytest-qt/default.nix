{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
, pyqt5
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-An89P13QSvBTDYRs9Q+4WPcZ9+h8LkocaGq9Tg9yFyo=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pyqt5
  ];

  # tests require X server
  doCheck = false;

  meta = with lib; {
    description = "pytest support for PyQt and PySide applications";
    homepage = "https://github.com/pytest-dev/pytest-qt";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
