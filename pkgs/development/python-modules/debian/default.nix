{ lib, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06e91d45019fe5f2e111ba827ea77730d6ce2fea698ada4e5b0b70b5fdbc18c5";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Debian package related modules";
    license = lib.licenses.gpl2;
  };
}
