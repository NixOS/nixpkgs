{ lib, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.39";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cca96239b5981f5203216d2113fea522477628607ed0a8427e15094a792541c";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Debian package related modules";
    license = lib.licenses.gpl2;
  };
}
