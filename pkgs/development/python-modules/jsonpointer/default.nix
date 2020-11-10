{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qjkjy1qlyc1nl3k95wd03ssxac0a717x8889ypgs1cfcj3bm4n1";
  };

  meta = with stdenv.lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = stdenv.lib.licenses.bsd2; # "Modified BSD license, says pypi"
  };

}
