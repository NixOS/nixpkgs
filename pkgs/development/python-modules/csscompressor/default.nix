{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "csscompressor";
  version = "0.9.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afa22badbcf3120a4f392e4d22f9fff485c044a1feda4a950ecc5eba9dd31a05";
  };

  doCheck = false; # No tests

  meta = with lib; {
    description = "A python port of YUI CSS Compressor";
    homepage = "https://pypi.python.org/pypi/csscompressor";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
