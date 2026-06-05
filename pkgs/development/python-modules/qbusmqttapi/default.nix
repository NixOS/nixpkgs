{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  hatchling,
  aiohttp,
  yarl,
}:

buildPythonPackage rec {
  pname = "qbusmqttapi";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qbus-iot";
    repo = "qbusmqttapi";
    tag = "v${version}";
    hash = "sha256-llFrgXtECdozAgz+RHTKig9sTKYJHfO7Rt5qz+/e7c8=";
  };

  postPatch = ''
    # Upstream uses a placeholder version in pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail '"0.0.0"' '"${version}"'
  '';

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "qbusmqttapi" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "MQTT API for Qbus Home Automation";
    homepage = "https://github.com/Qbus-iot/qbusmqttapi";
    changelog = "https://github.com/Qbus-iot/qbusmqttapi/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
