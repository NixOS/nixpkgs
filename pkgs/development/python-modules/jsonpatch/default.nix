{ lib
, buildPythonPackage
, fetchPypi
, jsonpointer
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.32";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2";
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
