{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:
buildPythonPackage rec {
  pname = "isodate";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TNGqD0PKdvSmxsApKoX0CzXsLkPjFbWfBubTIXGpU+Y=";
  };

  buildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "isodate" ];

  meta = {
    description = "ISO 8601 date/time parser";
    homepage = "http://cheeseshop.python.org/pypi/isodate";
    license = lib.licenses.bsd0;
  };
}
