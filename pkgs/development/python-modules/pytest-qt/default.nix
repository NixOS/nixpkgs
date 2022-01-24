{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pytest
, pyqt5
}:

buildPythonPackage rec {
  pname = "pytest-qt";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfc5240dec7eb43b76bcb5f9a87eecae6ef83592af49f3af5f1d5d093acaa93e";
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
