{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, cython
, packaging
, setuptools
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyemd";
  version = "1.0.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tCta57LRWx1N7mOBDqeYo5IX6Kdre0nA62OoTg/ZAP4=";
  };

  nativeBuildInputs = [
    cython
    packaging
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A Python wrapper for Ofir Pele and Michael Werman's implementation of the Earth Mover's Distance";
    homepage = "https://github.com/wmayner/pyemd";
    license = licenses.mit;
    maintainers = with maintainers; [ rvl ];
  };
}
