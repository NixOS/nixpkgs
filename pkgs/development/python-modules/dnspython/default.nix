{ buildPythonPackage, fetchPypi, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4";
  };

  # needs networking for some tests
  doCheck = false;

  meta = {
    description = "A DNS toolkit for Python 3.x";
    homepage = "http://www.dnspython.org";
    # BSD-like, check https://www.dnspython.org/LICENSE for details
    license = lib.licenses.free;
  };
}
