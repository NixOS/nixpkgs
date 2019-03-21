{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "0.4.15";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "9416443e219356e3c31f1f918a91badf2e37acf297e2fa13d24d1cc2380f8fbc";
  };

  propagatedBuildInputs = [ six ];

  # see https://github.com/python-greenlet/greenlet/issues/85
  preCheck = ''
    rm tests/test_leaks.py
  '';

  meta = {
    homepage = https://pypi.python.org/pypi/greenlet;
    description = "Module for lightweight in-process concurrent programming";
    license = lib.licenses.lgpl2;
  };
}