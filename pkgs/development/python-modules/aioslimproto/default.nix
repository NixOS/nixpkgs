{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pillow
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aioslimproto";
  version = "2.3.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-d+PEzCF1Cw/7NmumxIRRlr3hojpNsZM/JMQ0KWdosXk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    pillow
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
