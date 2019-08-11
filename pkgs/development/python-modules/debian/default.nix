{ lib, buildPythonPackage, fetchPypi
, chardet, six}:

buildPythonPackage rec {
  pname = "python-debian";
  version = "0.1.34";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a02e073214e9f3a371f7ec0ff8b34dd82bd4941194dd69c49ad80b321b9d887e";
  };

  propagatedBuildInputs = [ chardet six ];

  # No tests in archive
  doCheck = false;

  meta = {
    description = "Debian package related modules";
    license = lib.licenses.gpl2;
  };
}
