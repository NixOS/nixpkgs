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
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pburgio";
    repo = "iottyCloud";
    # https://github.com/pburgio/iottyCloud/issues/1
    rev = "c328cc497bf58a1da148ea88e309129177d69af0";
    hash = "sha256-G06kvp4VG0OmZxDqvKnMJ+uD+6i5BFL/Iuke4vOdO/k=";
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
