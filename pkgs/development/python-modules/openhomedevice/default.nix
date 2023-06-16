{ lib
, aioresponses
, async-upnp-client
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "openhomedevice";
  version = "2.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "bazwilliams";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-KNQelldqHx4m8IfgGUwWw/+AVzBotIa7cJGy1SfbRy0=";
  };

  propagatedBuildInputs = [
    async-upnp-client
    lxml
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "openhomedevice"
  ];

  pytestFlagsArray = [
    "tests/*.py"
  ];

  meta = with lib; {
    description = "Python module to access Linn Ds and Openhome devices";
    homepage = "https://github.com/bazwilliams/openhomedevice";
    changelog = "https://github.com/bazwilliams/openhomedevice/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
