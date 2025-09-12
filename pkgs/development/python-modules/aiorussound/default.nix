{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  mashumaro,
  orjson,
  pyserial-asyncio-fast,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiorussound";
  version = "4.8.1";
  pyproject = true;

  # requires newer f-strings introduced in 3.12
  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiorussound";
    tag = version;
    hash = "sha256-LagnFE5aWEoNYbthE01cM0fQBEGDF0ReJzSTvteg2BU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mashumaro
    orjson
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorussound" ];

  meta = with lib; {
    changelog = "https://github.com/noahhusby/aiorussound/releases/tag/${src.tag}";
    description = "Async python package for interfacing with Russound RIO hardware";
    homepage = "https://github.com/noahhusby/aiorussound";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
