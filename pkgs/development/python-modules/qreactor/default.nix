{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  twisted,
  qtpy,
  pyqt6,
}:

buildPythonPackage {
  pname = "qreactor-unstable";
  version = "0.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "frmdstryr";
    repo = "qt-reactor";
    rev = "364b3f561fb0d4d3938404d869baa4db7a982bf0";
    sha256 = "1nb5iwg0nfz86shw28a2kj5pyhd4jvvxhf73fhnfbl8scgnvjv9h";
  };

  strictDeps = true;

  propagatedBuildInputs = [
    twisted
    qtpy
  ];

  nativeCheckInputs = [ pyqt6 ];

  pythonImportsCheck = [ "qreactor" ];

  meta = {
    homepage = "https://github.com/frmdstryr/qt-reactor";
    description = "Twisted and PyQt5/qtpy eventloop integration base";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ raboof ];
  };
}
