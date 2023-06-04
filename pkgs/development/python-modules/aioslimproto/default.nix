{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "2.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ZvyAZ/VLkkZkDTBzuxt7hrCuYxNsMHm0C0wkabnE3Ek=";
  };

  propagatedBuildInputs = [
    async-timeout
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
