{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "0.4.17";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "41d8835c69a78de718e466dd0e6bfd4b46125f21a67c3ff6d76d8d8059868d6b";
  };

  requiredPythonModules = [ six ];

  # see https://github.com/python-greenlet/greenlet/issues/85
  preCheck = ''
    rm tests/test_leaks.py
  '';

  meta = {
    homepage = "https://pypi.python.org/pypi/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = lib.licenses.lgpl2;
  };
}
