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
  version = "1.16.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    hash = "sha256-R7vSz6VDACAQj59AMB4WbL6pi27z5TlTNQvdTGsxqxg=";
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
    homepage = "https://pypi.org/project/PyQt-builder/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
