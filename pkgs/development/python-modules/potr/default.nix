{
  lib,
  fetchPypi,
  buildPythonPackage,
  pycrypto,
}:

buildPythonPackage rec {
  pname = "python-potr";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Vuaf+r446aqqJhgn4oq2lVRjPUvwJFSd1xMWcmbjqY=";
  };

  propagatedBuildInputs = [ pycrypto ];

  meta = {
    description = "Pure Python OTR implementation";
    homepage = "https://github.com/python-otr/pure-python-otr";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
