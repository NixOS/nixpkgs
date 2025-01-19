{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytz";
  version = "2024.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KqNVCDxQoPk/pYFwnerAya1lzKip6b6sZgrcvUk8eYo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "pytz/tests"
  ];

  pythonImportsCheck = [ "pytz" ];

  meta = {
    changelog = "https://launchpad.net/pytz/+announcements";
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
