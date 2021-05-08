{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962";
  };

  meta = with lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = licenses.bsd2; # "Modified BSD license, says pypi"
  };

}
