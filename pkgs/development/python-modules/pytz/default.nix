{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2022.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6JUSQGt5PKOfWXG8mZzFOM4SXA5RwnlBvvRWi0YAleI=";
  };

  checkInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "pytz/tests" ];

  pythonImportsCheck = [ "pytz" ];

  meta = with lib; {
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
