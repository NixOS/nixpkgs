{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fuzzyfinder";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xW2G8RCGa+ytZpDHUY9wNsIIMcD4L8h+uo/blDEy8Es=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "fuzzyfinder" ];

  meta = with lib; {
    description = "Fuzzy Finder implemented in Python";
    homepage = "https://github.com/amjith/fuzzyfinder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
