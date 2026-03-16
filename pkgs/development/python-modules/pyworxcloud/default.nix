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

buildPythonPackage rec {
  pname = "pyworxcloud";
  version = "6.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pyworxcloud";
    tag = "v${version}";
    hash = "sha256-BqRdR202mF+aosAf1GRu8xcMSTkUrgxRVSgHyCg4wjA=";
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
    changelog = "https://github.com/MTrab/pyworxcloud/releases/tag/${src.tag}";
    license = with lib.licenses; [
      gpl3Only
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
