{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    hash = "sha256-7xFbxWay2aPCBkf3pBUGshROtssbi//PxxsI8ELeS+c=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aioslimproto"
  ];

  meta = with lib; {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
