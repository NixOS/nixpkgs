{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytz";
  version = "2024.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KilzXqnBi68UtEiEa95aSAMO0mdXhHLYlVzQ50Q6mBI=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "pytz/tests"
  ];

  pythonImportsCheck = [ "pytz" ];

  meta = with lib; {
    changelog = "https://launchpad.net/pytz/+announcements";
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
