{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "dnspython";
  version = "1.16.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01";
  };

  # needs networking for some tests
  doCheck = false;

  meta = {
    description = "A DNS toolkit for Python 3.x";
    homepage = http://www.dnspython.org;
    # BSD-like, check http://www.dnspython.org/LICENSE for details
    license = lib.licenses.free;
  };
}
