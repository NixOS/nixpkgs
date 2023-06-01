{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ku96N3n71mrYuott6E6UwbloP6RzM9tiEATvYHzdYnM=";
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
