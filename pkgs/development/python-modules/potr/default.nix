{
  lib,
  fetchPypi,
  buildPythonPackage,
  pycrypto,
}:

buildPythonPackage rec {
  pname = "python-potr";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Vuaf+r446aqqJhgn4oq2lVRjPUvwJFSd1xMWcmbjqY=";
  };

  propagatedBuildInputs = [ pycrypto ];

  meta = with lib; {
    description = "Pure Python OTR implementation";
    homepage = "http://python-otr.pentabarf.de/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
