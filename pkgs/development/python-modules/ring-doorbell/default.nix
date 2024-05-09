{
  lib,
  asyncclick,
  buildPythonPackage,
  fetchPypi,
  firebase-messaging,
  oauthlib,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  pythonOlder,
  pytz,
  requests,
  requests-mock,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "ring-doorbell";
  version = "0.8.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit version;
    hash = "sha256-XygVfIf6zlKy2kv/9TKLG8MpYX4YnzYIKiSG7nP5YI8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    asyncclick
    oauthlib
    pytz
    requests
    requests-oauthlib
  ];

  passthru.optional-dependencies = {
    listen = [ firebase-messaging ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "ring_doorbell" ];

  meta = with lib; {
    description = "Library to communicate with Ring Door Bell";
    homepage = "https://github.com/tchellomello/python-ring-doorbell";
    changelog = "https://github.com/tchellomello/python-ring-doorbell/releases/tag/${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ graham33 ];
    mainProgram = "ring-doorbell";
  };
}
