{ lib
, buildPythonPackage
, fetchPypi
, jsonpointer
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.20";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b12594a0cfe634bdd2a5c027250af2dd84932d493568e88ae722871edc3eb02d";
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
