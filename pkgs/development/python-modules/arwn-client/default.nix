{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  click,
  paho-mqtt,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arwn-client";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sdague";
    repo = "arwn-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-By4dZlzR3It4UkYss+RPsKt9Easkegv6VbLd0SSaC2U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    click
    paho-mqtt
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "arwn_client" ];

  meta = {
    description = "Python client library for parsing ARWN weather station MQTT messages";
    homepage = "https://github.com/sdague/arwn-client";
    changelog = "https://github.com/sdague/arwn-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "arwn-client";
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
