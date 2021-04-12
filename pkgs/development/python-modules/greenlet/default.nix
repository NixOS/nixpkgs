{ lib
, buildPythonPackage
, fetchPypi
, six
, isPyPy
}:


buildPythonPackage rec {
  pname = "greenlet";
  version = "1.0.0";
  disabled = isPyPy;  # builtin for pypy

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y6wbg9yhm9dw6m768n4yslp56h85pnxkk3drz6icn15g6f1d7ki";
  };

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = "https://pypi.python.org/pypi/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = lib.licenses.lgpl2;
  };
}
