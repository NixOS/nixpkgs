{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f09f8deecaaa5aea65b5eb4f67ca4e54e1a61f7a11c75085e360fe6feb6a48bf";
  };

  meta = with lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
  };

}
