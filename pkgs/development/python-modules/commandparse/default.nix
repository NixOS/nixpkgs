{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "commandparse";
  version = "1.1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-S9e90BtS6qMjFtYUmgC0w4IKQP8q1iR2tGqq5l2+n6o=";
  };

  build-system = [ setuptools ];

  # tests only distributed upstream source, not PyPi
  doCheck = false;

  pythonImportsCheck = [ "commandparse" ];

  meta = {
    description = "Python module to parse command based CLI application";
    homepage = "https://github.com/flgy/commandparse";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.fab ];
  };
})
