{
  lib,
  buildPythonPackage,
  fetchPypi,
  jalali-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "5.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0g65/CoA6GSTphVrKg5OV58jN56P6hhqDmA/02oTAic=";
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
