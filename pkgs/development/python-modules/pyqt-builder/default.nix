{
  lib,
  buildPythonPackage,
  fetchPypi,
  packaging,
  setuptools,
  setuptools-scm,
  sip,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyqt-builder";
  version = "1.16.4";
  format = "pyproject";

  src = fetchPypi {
    pname = "pyqt_builder";
    inherit version;
    hash = "sha256-RRXkGuN5vi5U+IqJ7PR81uTKxD6GLEq/3hg4nCZmr98=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    packaging
    sip
  ];

  pythonImportsCheck = [ "pyqtbuild" ];

  # There aren't tests
  doCheck = false;

  meta = with lib; {
    description = "PEP 517 compliant build system for PyQt";
    homepage = "https://github.com/Python-PyQt/PyQt-builder";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
