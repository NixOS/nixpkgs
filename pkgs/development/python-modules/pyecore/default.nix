{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  restrictedpython,
  ordered-set,
  future-fstrings,
  lxml,
}:

buildPythonPackage rec {
  pname = "pyecore";
  version = "0.15.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "vdq26G0si26Lgk2duov9vxmNbxK9Ag5qjD3bG8c9bAI=";
  };

  propagatedBuildInputs = [
    ordered-set
    restrictedpython
    future-fstrings
    lxml
  ];
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  pythonImportsCheck = [ "pyecore" ];

  meta = with lib; {
    description = "A Python(ic) Implementation of EMF/Ecore";
    homepage = "https://github.com/pyecore/pyecore";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Donvini94 ];
  };
}
