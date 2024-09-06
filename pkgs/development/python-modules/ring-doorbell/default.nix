{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  asyncclick,
  buildPythonPackage,
  fetchPypi,
  firebase-messaging,
  freezegun,
  oauthlib,
  poetry-core,
  pytest-asyncio,
  pytest-freezer,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  pytz,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "ring-doorbell";
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    hash = "sha256-jzhboyDq3PXkwKKrAehX1F1UEUo9qofb+Z4/W5vwjiU=";
  };

  pythonRelaxDeps = [ "requests-oauthlib" ];

  build-system = [ poetry-core ];

  dependencies = [
    aiofiles
    aiohttp
    asyncclick
    oauthlib
    pytz
    typing-extensions
  ];

  optional-dependencies = {
    listen = [ firebase-messaging ];
  };

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytest-freezer
    pytest-mock
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ring_doorbell" ];

  meta = with lib; {
    description = "Library to communicate with Ring Door Bell";
    homepage = "https://github.com/tchellomello/python-ring-doorbell";
    changelog = "https://github.com/tchellomello/python-ring-doorbell/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ graham33 ];
    mainProgram = "ring-doorbell";
  };
}
