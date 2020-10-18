{ lib, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.38";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a352bb5f9ef19b0272078f516ee0ec42b05e90ac85651d87c10e7041550dcc1d";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Debian package related modules";
    license = lib.licenses.gpl2;
  };
}
