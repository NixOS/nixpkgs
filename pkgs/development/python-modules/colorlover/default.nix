{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorlover";
  version = "0.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uPtyRqtG4fXmcVZJRTwXYuJFpRXeX/LStKq3puZ/pOI=";
  };

  build-system = [ setuptools ];

  # no tests included in distributed archive
  doCheck = false;

  pythonImportsCheck = [ "colorlover" ];

  meta = {
    homepage = "https://github.com/plotly/colorlover";
    description = "Color scales in Python for humans";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
