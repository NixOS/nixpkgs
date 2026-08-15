{
  lib,
  buildPythonPackage,
  fetchPypi,
  jalali-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5YEtfr9MZgmlVCMMwH3vyJ2cETQkNQ/i1bftfcUNMJc=";
  };

  build-system = [ setuptools ];

  dependencies = [ jalali-core ];

  pythonImportsCheck = [ "jdatetime" ];

  meta = {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    changelog = "https://github.com/slashmili/python-jalali/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.psfl;
    maintainers = [ ];
  };
}
