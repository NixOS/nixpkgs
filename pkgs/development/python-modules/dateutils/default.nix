{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  python-dateutil,
  pytz,
}:

buildPythonPackage (finalAttrs: {
  pname = "dateutils";
  version = "0.6.12";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "dateutils";
    inherit (finalAttrs) version;
    hash = "sha256-A92QvLIVQb1OtLATY35PG1+USIHEbMbktnpgWeNw4/E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "dateutils" ];

  meta = {
    description = "Utilities for working with datetime objects";
    homepage = "https://github.com/jmcantrell/python-dateutils";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
})
