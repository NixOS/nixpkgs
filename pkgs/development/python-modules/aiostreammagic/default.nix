{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pythonOlder,
  websockets,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiostreammagic";
  version = "2.8.4";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "noahhusby";
    repo = "aiostreammagic";
    rev = "refs/tags/${version}";
    hash = "sha256-TleCQjx1s8S1YTxh/d1T3oozQAwzPTCurzjLjDCebik=";
  };

  pythonRelaxDeps = [ "websockets" ];

  build-system = [ poetry-core ];

  dependencies = [
    mashumaro
    orjson
    websockets
    yarl
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "aiostreammagic" ];

  meta = {
    description = "Module for interfacing with Cambridge Audio/Stream Magic compatible streamers";
    homepage = "https://github.com/noahhusby/aiostreammagic";
    changelog = "https://github.com/noahhusby/aiostreammagic/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
