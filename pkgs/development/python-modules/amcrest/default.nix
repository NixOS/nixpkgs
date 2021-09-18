{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, mock
, httpx
, pytestCheckHook
, pythonOlder
, requests
, responses
, urllib3
, typing-extensions
}:

buildPythonPackage rec {
  pname = "amcrest";
  version = "1.9.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-amcrest";
    rev = version;
    sha256 = "sha256-xBrXe3BUvLfSk7zBHVJLh/K3lGVkFKOCq0RNAOb9GqI=";
  };

  propagatedBuildInputs = [
    argcomplete
    httpx
    requests
    urllib3
    typing-extensions
  ];

  checkInputs = [
    mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "amcrest" ];

  meta = with lib; {
    description = "Python module for Amcrest and Dahua Cameras";
    homepage = "https://github.com/tchellomello/python-amcrest";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
