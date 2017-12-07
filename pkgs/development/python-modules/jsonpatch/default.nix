{ lib
, buildPythonPackage
, fetchPypi
, jsonpointer
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.16";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f025c28a08ce747429ee746bb21796c3b6417ec82288f8fe6514db7398f2af8a";
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
