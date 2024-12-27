{
  lib,
  buildPythonPackage,
  flet-client-flutter,

  # build-system
  poetry-core,
  pytestCheckHook,

  # propagates
  fastapi,
  httpx,
  oauthlib,
  packaging,
  qrcode,
  repath,
  cookiecutter,
  uvicorn,
  watchdog,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "flet";
  inherit (flet-client-flutter) version src;
  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet";

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  makeWrapperArgs = [
    "--prefix"
    "PYTHONPATH"
    ":"
    "$PYTHONPATH"
  ];

  pythonRelaxDeps = [
    "cookiecutter"
    "packaging"
    "qrcode"
    "watchdog"
    "websockets"
  ];

  dependencies = [
    fastapi
    uvicorn
    websocket-client
    watchdog
    oauthlib
    websockets
    httpx
    packaging
    repath
    qrcode
    cookiecutter
    fastapi
    uvicorn
  ];

  pythonImportsCheck = [ "flet" ];

  meta = {
    description = "Framework that enables you to easily build realtime web, mobile, and desktop apps in Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      heyimnova
      lucasew
    ];
    mainProgram = "flet";
  };
}
