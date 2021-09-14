{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, requests
, responses
, urllib3
, typing-extensions
}:

buildPythonPackage rec {
  pname = "amcrest";
  version = "1.8.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "tchellomello";
    repo = "python-amcrest";
    rev = version;
    sha256 = "sha256-a23AjLRNghu5CT3GHvnti0BHnku9CxLP1EkE0GrwB3w=";
  };

  propagatedBuildInputs = [
    argcomplete
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
