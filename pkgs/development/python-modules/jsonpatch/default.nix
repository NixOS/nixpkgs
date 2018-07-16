{ lib
, buildPythonPackage
, fetchPypi
, jsonpointer
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49f29cab70e9068db3b1dc6b656cbe2ee4edf7dfe9bf5a0055f17a4b6804a4b9";
  };

  # test files are missing
  doCheck = false;
  propagatedBuildInputs = [ jsonpointer ];

  meta = {
    description = "Library to apply JSON Patches according to RFC 6902";
    homepage = "https://github.com/stefankoegl/python-json-patch";
    license = lib.licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
