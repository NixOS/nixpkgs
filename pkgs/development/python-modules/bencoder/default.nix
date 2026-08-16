{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "bencoder";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rENvM/3X51stkFdJHSq+77VjHvsTyBNAPbCtsRq1L8I=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "bencoder" ];

  # There are no tests.
  doCheck = false;

  meta = {
    description = "Simple bencode decoder/encoder library in pure Python";
    homepage = "https://github.com/utdemir/bencoder";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ somasis ];
  };
})
