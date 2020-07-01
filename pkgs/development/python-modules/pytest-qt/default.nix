{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pytest
, pyqt5
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "714b0bf86c5313413f2d300ac613515db3a1aef595051ab8ba2ffe619dbe8925";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
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
