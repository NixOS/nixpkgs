{ lib
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytestCheckHook
, pythonOlder
, srsly
}:

buildPythonPackage rec {
  pname = "confection";
  version = "0.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "explosion";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3qxB94CYCMZN+sKqbmDfkRyAs6HJkFLE/5yJx1DKqYM=";
  };

  propagatedBuildInputs = [
    pydantic
    srsly
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "confection"
  ];

  meta = with lib; {
    description = "Library that offers a configuration system";
    homepage = "https://github.com/explosion/confection";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
