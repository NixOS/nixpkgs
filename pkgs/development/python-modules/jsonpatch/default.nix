{ lib
, buildPythonPackage
, fetchPypi
, jsonpointer
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e45df18b0ab7df1925f20671bbc3f6bd0b4b556fb4b9c5d97684b0a7eac01744";
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
