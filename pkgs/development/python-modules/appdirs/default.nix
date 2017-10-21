{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "appdirs";
  version = "1.4.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92";
  };

  meta = {
    description = "A python module for determining appropriate platform-specific dirs";
    homepage = http://github.com/ActiveState/appdirs;
    license = lib.licenses.mit;
  };
}
