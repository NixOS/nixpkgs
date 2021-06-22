{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, requests
, pytestCheckHook
, responses
}:

buildPythonPackage rec {
  pname = "herepy";
  version = "3.5.2";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "abdullahselek";
    repo = "HerePy";
    rev = version;
    sha256 = "0z1brgnrzdzfmnydipja4hhrhnz4fwdjy3xa05mz28bwi6z52bcj";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "herepy" ];

  meta = with lib; {
    description = "Library that provides a Python interface to the HERE APIs";
    homepage = "https://github.com/abdullahselek/HerePy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
