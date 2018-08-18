{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "0.4.14";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1cc268a15ade58d9a0c04569fe6613e19b8b0345b64453064e2c3c6d79051af";
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