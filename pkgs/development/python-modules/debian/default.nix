{ lib, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.36";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c953bb0c54e96887badd2324cc66e1887bf2734f301882cd4fe847a844b518a6";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Debian package related modules";
    license = lib.licenses.gpl2;
  };
}
