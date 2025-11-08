{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-madvr2";
  version = "1.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iloveicedgreentea";
    repo = "py-madvr";
    tag = "v${version}";
    hash = "sha256-7zYvbEoPlY49YZ9Akq+SfzMmqClrr3xTszVW2FUx62Y=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pymadvr" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Expected 'mock' to have been called once. Called 0 times.
    "test_power_off"
    # tests connect to 192.168.1.100
    "test_basic_connection"
    "test_display_message"
    "test_ha_command_formats"
    "test_open_connection"
  ];

  meta = {
    changelog = "https://github.com/iloveicedgreentea/py-madvr/releases/tag/${src.tag}";
    description = "Control MadVR Envy over IP";
    homepage = "https://github.com/iloveicedgreentea/py-madvr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
