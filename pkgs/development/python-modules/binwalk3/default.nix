{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "binwalk3";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-qTDEDGnR+ivRuy7zsqrs/cP0bECvox0t/D3zWYquWmg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "binwalk" ];

  # Tests are not available on PyPI
  doCheck = false;

  meta = {
    description = "Binwalk v3 with v2-compatible Python API";
    homepage = "https://pypi.org/project/binwalk3/";
    changelog = "https://github.com/ZachFlint/Binwalk3/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
