{
  lib,
  fetchPypi,
  buildPythonPackage,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dbfread";
  version = "2.0.7";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-B8iprwb/rT9vA+j+ka19JzPjGibStyxN1M+64H7jtz0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "dbfread" ];

  meta = {
    description = "Read DBF Files with Python";
    homepage = "https://dbfread.readthedocs.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
