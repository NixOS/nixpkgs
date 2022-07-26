{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ordered-set";
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aUqORMh2V8WSku3nKJHrkdNBMfZTFGOqswCRkcdzZKg=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ordered_set"
  ];

  meta = with lib; {
    description = "A MutableSet that remembers its order, so that every entry has an index.";
    homepage = "https://github.com/rspeer/ordered-set";
    license = licenses.mit;
    maintainers = with maintainers; [ MostAwesomeDude ];
  };
}
