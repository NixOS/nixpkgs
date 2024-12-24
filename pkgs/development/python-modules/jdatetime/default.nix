{
  lib,
  buildPythonPackage,
  fetchPypi,
  jalali-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jdatetime";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LMYD2RPA2OMokoRU09KVJhywN+mVAif2fJYpq0cQ/fk=";
  };

  build-system = [ setuptools ];

  dependencies = [ jalali-core ];

  pythonImportsCheck = [ "jdatetime" ];

  meta = with lib; {
    description = "Jalali datetime binding";
    homepage = "https://github.com/slashmili/python-jalali";
    changelog = "https://github.com/slashmili/python-jalali/blob/v${version}/CHANGELOG.md";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
