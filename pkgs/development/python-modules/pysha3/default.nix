{ lib, buildPythonPackage, fetchPypi, pythonOlder }:

buildPythonPackage rec {
  pname = "pysha3";
  version = "1.0.2";
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17kkjapv6sr906ib0r5wpldmzw7scza08kv241r98vffy9rqx67y";
  };

  meta = {
    description = "Backport of hashlib.sha3 for 2.7 to 3.5";
    homepage = "https://github.com/tiran/pysha3";
    license = lib.licenses.psfl;
  };
}
