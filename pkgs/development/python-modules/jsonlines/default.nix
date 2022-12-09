{ lib
, attrs
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonlines";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "wbolster";
    repo = pname;
    rev = version;
    hash = "sha256-eMpUk5s49OyD+cNGdAeKA2LvpXdKta2QjZIFDnIBKC8=";
  };

  propagatedBuildInputs = [
    attrs
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonlines"
  ];

  meta = with lib; {
    description = "Python library to simplify working with jsonlines and ndjson data";
    homepage = "https://github.com/wbolster/jsonlines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
