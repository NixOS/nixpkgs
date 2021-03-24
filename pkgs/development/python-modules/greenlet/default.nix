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
    sha256 = "719e169c79255816cdcf6dccd9ed2d089a72a9f6c42273aae12d55e8d35bdcf8";
  };

  propagatedBuildInputs = [ six ];

  # No tests in archive
  doCheck = false;

  meta = {
    homepage = "https://pypi.python.org/pypi/greenlet";
    description = "Module for lightweight in-process concurrent programming";
    license = lib.licenses.lgpl2;
  };
}
