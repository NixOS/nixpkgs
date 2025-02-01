{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  twisted,
  qtpy,
  pyqt5,
}:

buildPythonPackage rec {
  pname = "qreactor-unstable";
  version = "2018-09-29";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = "qt-reactor";
    rev = "364b3f561fb0d4d3938404d869baa4db7a982bf0";
    sha256 = "1nb5iwg0nfz86shw28a2kj5pyhd4jvvxhf73fhnfbl8scgnvjv9h";
  };

  propagatedBuildInputs = [
    twisted
    qtpy
  ];

  nativeCheckInputs = [ pyqt5 ];

  pythonImportsCheck = [ "qreactor" ];

  meta = with lib; {
    homepage = "https://github.com/frmdstryr/qt-reactor";
    description = "Twisted and PyQt5/qtpy eventloop integration base";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
  };
}
