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
  version = "1.15.4";
  format = "pyproject";

  src = fetchPypi {
    pname = "PyQt-builder";
    inherit version;
    hash = "sha256-OfjHXbF9nOF8trvz3xZQtc68HqTlvXOEPSHMlmErKuE=";
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
