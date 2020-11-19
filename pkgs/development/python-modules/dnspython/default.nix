{ buildPythonPackage, fetchPypi, lib, pythonOlder }:

buildPythonPackage rec {
  pname = "dnspython";
  version = "2.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7";
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
