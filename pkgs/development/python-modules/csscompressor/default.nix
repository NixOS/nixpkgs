{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "csscompressor";
  version = "0.9.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "afa22badbcf3120a4f392e4d22f9fff485c044a1feda4a950ecc5eba9dd31a05";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python port of YUI CSS Compressor";
    homepage = "https://pypi.org/project/csscompressor/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
