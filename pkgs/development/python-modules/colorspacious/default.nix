{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorspacious";
  version = "1.1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XpBy6M3KiJ2sRFw1yTYqIsz3WOl7ALef8NWnuj4Rthg=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  pythonImportsCheck = [ "colorspacious" ];

  meta = {
    homepage = "https://github.com/njsmith/colorspacious";
    description = "Powerful, accurate, and easy-to-use Python library for doing colorspace conversions";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
