{
  lib,
  aiohttp,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "govee-led-wez";
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wez";
    repo = "govee-py";
    # https://github.com/wez/govee-py/issues/2
    rev = "931273e3689838613d63bc1bcc65ee744fa999f4";
    hash = "sha256-VMH7sot9e2SYMyBNutyW6oCCjp2N+EKukxn1Dla3AlY=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    aiohttp
    bleak
    bleak-retry-connector
    certifi
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "govee_led_wez" ];

  meta = {
    description = "Control Govee Lights from Python";
    homepage = "https://github.com/wez/govee-py";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
