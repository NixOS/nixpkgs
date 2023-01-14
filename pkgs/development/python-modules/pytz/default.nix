{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2022.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fM+ue0ssBnRkpnM8YmFnP9uP0b6QVGA5a5egc+n6aDo=";
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
