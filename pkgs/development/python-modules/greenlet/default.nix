{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "0.4.16";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e06eac722676797e8fce4adb8ad3dc57a1bb3adfb0dd3fdf8306c055a38456c";
  };

  propagatedBuildInputs = [ six ];

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
