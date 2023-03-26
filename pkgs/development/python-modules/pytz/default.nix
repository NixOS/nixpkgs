{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2023.2";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-on3PYSwF0uveYm99UGVV8Q38gVs+3cz6rfx9mbEcmgc=";
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
