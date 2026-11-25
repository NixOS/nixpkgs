{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  hatchling,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qbusmqttapi";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qbus-iot";
    repo = "qbusmqttapi";
    tag = "v${version}";
    hash = "sha256-jEXG3oxm6vk4lcs1MVoD5MmqucbPQ4uzgnsQM1Jhq1c=";
  };

  postPatch = ''
    # Upstream uses a placeholder version in pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
  '';

  build-system = [ hatchling ];

  pythonImportsCheck = [ "qbusmqttapi" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "MQTT API for Qbus Home Automation";
    homepage = "https://github.com/Qbus-iot/qbusmqttapi";
    changelog = "https://github.com/Qbus-iot/qbusmqttapi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
