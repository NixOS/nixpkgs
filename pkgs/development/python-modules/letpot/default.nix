{
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "letpot";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpelgrom";
    repo = "python-letpot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w4WS0AyNd4dNtA/fBKieDW2YXwBFltRkJvaGemRjsv4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
  ];

  pythonImportsCheck = [ "letpot" ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jpelgrom/python-letpot/releases/tag/${finalAttrs.src.tag}";
    description = "Asynchronous Python client for LetPot hydroponic gardens";
    homepage = "https://github.com/jpelgrom/python-letpot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
