{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cachetools";
  version = "5.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tkem";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DheHTD62f1ZxoiS0y0/CzDMHvKGmEiEUAX6oaqTpB78=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "cachetools"
  ];

  meta = with lib; {
    description = "Extensible memoizing collections and decorators";
    homepage = "https://github.com/tkem/cachetools";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
