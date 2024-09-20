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
  hatchling,
  oauthlib,
  pytest-asyncio,
  pytest-freezer,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  pytz,
  typing-extensions,
  websockets,
}:

buildPythonPackage rec {
  pname = "ring-doorbell";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    hash = "sha256-NnKcUr0SExXRDkNCIGU3LtwU1LIMAZzurn2Aoua1lzA=";
  };

  pythonRelaxDeps = [ "requests-oauthlib" ];

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiohttp
    asyncclick
    oauthlib
    pytz
    typing-extensions
    websockets
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
