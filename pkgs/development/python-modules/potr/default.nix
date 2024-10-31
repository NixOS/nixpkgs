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
    sha256 = "f95b9a7feaf8e3a6aaa898609f8a2ada55518cf52fc09152775c4c59c99b8ea6";
  };

  propagatedBuildInputs = [ pycrypto ];

  meta = with lib; {
    description = "Pure Python OTR implementation";
    homepage = "http://python-otr.pentabarf.de/";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
