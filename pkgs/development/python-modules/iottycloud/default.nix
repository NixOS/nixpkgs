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
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pburgio";
    repo = "iottyCloud";
    rev = "refs/tags/v${version}";
    hash = "sha256-EtAAUyVL7FTn0VoGmU5bU9XouMuEQUOx2t6j/wd1OEo=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "iottycloud" ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  meta = {
    changelog = "https://github.com/pburgio/iottyCloud/releases/tag/v${version}";
    description = "Python library to interact with iotty CloudApi";
    homepage = "https://github.com/pburgio/iottyCloud";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
