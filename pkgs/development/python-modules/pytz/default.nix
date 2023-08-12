{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2023.3";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HYzinbGJGR+1UzjubQOH2Cq1nz0A6sEDQS1k4OvQxYg=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "-s" "pytz/tests" ];

  pythonImportsCheck = [ "pytz" ];

  meta = with lib; {
    description = "World timezone definitions, modern and historical";
    homepage = "https://pythonhosted.org/pytz";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
