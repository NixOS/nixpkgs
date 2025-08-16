{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  paho-mqtt,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "pyworxcloud";
  version = "4.1.43";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MTrab";
    repo = "pyworxcloud";
    tag = "v${version}";
    hash = "sha256-DMkyek9Y3vQnzcds5MUALVH3o1dW6X6eIkurFC8rLO4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
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
