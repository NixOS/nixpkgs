{ buildPythonPackage, fetchPypi, lib }:

buildPythonPackage rec {
  pname = "dnspython";
  version = "1.15.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0z5d9vwf211v54bybrhm3qpxclys4dfdfsp7lk2hvf57yzhn7xa0";
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
