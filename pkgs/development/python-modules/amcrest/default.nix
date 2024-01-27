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
  version = "1.9.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-amcrest";
    rev = "refs/tags/${version}";
    hash = "sha256-v0jWEZo06vltEq//suGrvJ/AeeDxUG5CCFhbf03q34w=";
  };

  propagatedBuildInputs = [
    argcomplete
    httpx
    requests
    urllib3
    typing-extensions
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "amcrest"
  ];

  meta = with lib; {
    description = "Python module for Amcrest and Dahua Cameras";
    homepage = "https://github.com/tchellomello/python-amcrest";
    changelog = "https://github.com/tchellomello/python-amcrest/releases/tag/${version}";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
