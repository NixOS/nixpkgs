{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiofiles,
  aiohttp,
  boto3,
  paho-mqtt,
  pyopenssl,
  python-decouple,
}:

buildPythonPackage (finalAttrs: {
  pname = "homelink-integration-api";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Gentex-Corporation";
    repo = "homelink-integration-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ELEqx41JSAmXBEowwJ1tYPZV40hMjswaHQonD+1IG5E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    boto3
    paho-mqtt
    pyopenssl
    python-decouple
  ];

  # upstream tests require network access and AWS credentials
  doCheck = false;

  pythonImportsCheck = [ "homelink" ];

  meta = {
    description = "API to interact with Homelink cloud for MQTT-enabled smart home platforms";
    homepage = "https://github.com/Gentex-Corporation/homelink-integration-api";
    changelog = "https://github.com/Gentex-Corporation/homelink-integration-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
