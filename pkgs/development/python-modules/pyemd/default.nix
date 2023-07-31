{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, cython
, packaging
, setuptools
, setuptools-scm
, wheel
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

  # update constraint to accept numpy from nixpkgs
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'oldest-supported-numpy' 'numpy'
  '';

  nativeBuildInputs = [
    cython
    packaging
    setuptools
    setuptools-scm
    wheel
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
