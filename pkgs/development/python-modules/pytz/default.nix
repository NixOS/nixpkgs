{ lib, buildPythonPackage, fetchPypi, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pytz";
  version = "2023.3.post1";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e0/dvrlKHrpLVX2iTxn9+dtXUZJUQnCpEB2FCfn0PXs=";
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
