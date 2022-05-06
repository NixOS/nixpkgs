{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = version;
    hash = "sha256-xa0LZGq0di4lnJGVMbb1Un0Ebd4vXRlbkxbatJ9GwB0=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: assert ['mixer', 'volume', '50'] == ['volume', '50']
    "test_msg_instantiation"
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
