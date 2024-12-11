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

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiorussound";
  version = "4.1.0";
  pyproject = true;

  # requires newer f-strings introduced in 3.12
  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiorussound";
    rev = "refs/tags/${version}";
    hash = "sha256-uMVmP4wXF6ln5A/iECf075B6gVnEzQxDTEPcyv5osyM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiorussound" ];

  meta = with lib; {
    changelog = "https://github.com/noahhusby/aiorussound/releases/tag/${version}";
    description = "Async python package for interfacing with Russound RIO hardware";
    homepage = "https://github.com/noahhusby/aiorussound";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
