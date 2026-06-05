{
  lib,
  aiohttp,
  awsiotsdk,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  paho-mqtt,
  requests,
  urllib3,
  tzdata,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyworxcloud";
  version = "6.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pyworxcloud";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r3v9cGr3ko/ALkM56mKsPUoUv+r5hmX5hflNdyKol58=";
  };

  pythonRelaxDeps = [ "awsiotsdk" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awsiotsdk
    paho-mqtt
    requests
    urllib3
    tzdata
  ];

  pythonImportsCheck = [ "pyworxcloud" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for integrating with Worx Cloud devices";
    homepage = "https://github.com/MTrab/pyworxcloud";
    changelog = "https://github.com/MTrab/pyworxcloud/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
