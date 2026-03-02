{
  lib,
  awsiotsdk,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  paho-mqtt,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pyworxcloud";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pyworxcloud";
    tag = "v${version}";
    hash = "sha256-eyMMtLgJuBIuPCyenYrHaRQIrb2tzPaIzM2UCAPPqDg=";
  };

  pythonRelaxDeps = [ "awsiotsdk" ];

  build-system = [ poetry-core ];

  dependencies = [
    awsiotsdk
    paho-mqtt
    requests
    urllib3
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
