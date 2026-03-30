{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  asyncclick,
  buildPythonPackage,
  fetchpatch,
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
  pytz,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "ring-doorbell";
  version = "0.9.14";
  pyproject = true;

  src = fetchPypi {
    pname = "ring_doorbell";
    inherit (finalAttrs) version;
    hash = "sha256-M99nwMuo0OziuJpNzuZgK69HtE+/wbOgheij1UwBaRc=";
  };

  patches = [
    # https://github.com/python-ring-doorbell/python-ring-doorbell/pull/494
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/python-ring-doorbell/python-ring-doorbell/commit/771243153921ec2cfb5f103b08ed08cccbe2e760.patch";
      excludes = [
        ".github/workflows/ci.yml"
        "uv.lock"
      ];
      hash = "sha256-l6CUg3J6FZ0c0v0SSqvndjl4XeBhGFy/uWHPkExCM50=";
    })
  ];

  pythonRelaxDeps = [ "requests-oauthlib" ];

  build-system = [ hatchling ];

  dependencies = [
    aiofiles
    aiohttp
    asyncclick
    firebase-messaging
    oauthlib
    pytz
    typing-extensions
    websockets
  ];

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

  meta = {
    description = "Library to communicate with Ring Door Bell";
    homepage = "https://github.com/tchellomello/python-ring-doorbell";
    changelog = "https://github.com/tchellomello/python-ring-doorbell/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ graham33 ];
    mainProgram = "ring-doorbell";
  };
})
