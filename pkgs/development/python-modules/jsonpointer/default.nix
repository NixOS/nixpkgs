{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "1.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "39403b47a71aa782de6d80db3b78f8a5f68ad8dfc9e674ca3bb5b32c15ec7308";
  };

  meta = with stdenv.lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = stdenv.lib.licenses.bsd2; # "Modified BSD license, says pypi"
  };

}
