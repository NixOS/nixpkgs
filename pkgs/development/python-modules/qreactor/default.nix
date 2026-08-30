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
    hash = "sha256-MG257WMa0eUsdOM42PeWpEF/i5xCIcGhNug7Cx6PZdk=";
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
