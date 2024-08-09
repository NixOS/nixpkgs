{
  lib,
  aioresponses,
  async-upnp-client,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "openhomedevice";
  version = "2.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bazwilliams";
    repo = "openhomedevice";
    rev = "refs/tags/${version}";
    hash = "sha256-q8UG+PYtJ7lLlnw2Rt5O/SxOrUtYmwO1cEG1WocaQ7M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    async-upnp-client
    lxml
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/bazwilliams/openhomedevice/issues/23
    "test_two"
    "test_three"
  ];

  pythonImportsCheck = [ "openhomedevice" ];

  pytestFlagsArray = [ "tests/*.py" ];

  meta = with lib; {
    description = "Python module to access Linn Ds and Openhome devices";
    homepage = "https://github.com/bazwilliams/openhomedevice";
    changelog = "https://github.com/bazwilliams/openhomedevice/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
