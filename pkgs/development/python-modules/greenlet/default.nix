{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "0.4.13";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fef83d43bf87a5196c91e73cb9772f945a4caaff91242766c5916d1dd1381e4";
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