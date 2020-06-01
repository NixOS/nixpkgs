{ lib, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.37";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab04f535155810c46c8abf3f7d46364b67b034c49ff8690cdb510092eee56750";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Debian package related modules";
    license = lib.licenses.gpl2;
  };
}
