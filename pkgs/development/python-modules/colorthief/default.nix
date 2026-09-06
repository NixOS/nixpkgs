{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "colorthief";
  version = "0.2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fengsp";
    repo = "color-thief-py";
    tag = finalAttrs.version;
    hash = "sha256-FQrFDHj9VaAG4J0PhqwWDhMBftHaK3gmkQvHQBV191M=";
  };

  build-system = [ setuptools ];

  dependencies = [ pillow ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "colorthief" ];

  meta = {
    description = "Python module for grabbing the color palette from an image";
    homepage = "https://github.com/fengsp/color-thief-py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
