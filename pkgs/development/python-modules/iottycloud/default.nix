{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "iottycloud";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pburgio";
    repo = "iottyCloud";
    tag = version;
    hash = "sha256-tsCa87BdwKumsv5N0lAPZmMIfm2W6Pw0LS3sF9c/oRA=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "iottycloud" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  meta = {
    changelog = "https://github.com/pburgio/iottyCloud/releases/tag/${version}";
    description = "Python library to interact with iotty CloudApi";
    homepage = "https://github.com/pburgio/iottyCloud";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
