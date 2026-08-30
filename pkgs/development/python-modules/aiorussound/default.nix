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
  serialx,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiorussound";
  version = "5.0.2";
  pyproject = true;

  # requires newer f-strings introduced in 3.12
  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiorussound";
    tag = version;
    hash = "sha256-mzehFObsX8+A8OZsGUN1hXeyXYyfxBft/SWJtIMfMYE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mashumaro
    orjson
    serialx
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorussound" ];

  meta = {
    changelog = "https://github.com/noahhusby/aiorussound/releases/tag/${src.tag}";
    description = "Async python package for interfacing with Russound RIO hardware";
    homepage = "https://github.com/noahhusby/aiorussound";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
