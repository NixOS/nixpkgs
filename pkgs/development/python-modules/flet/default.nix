{ lib
, buildPythonPackage
, flet-client-flutter
, pythonRelaxDepsHook

# build-system
, poetry-core

# propagates
, fastapi
, flet-core
, flet-runtime
, httpx
, oauthlib
, packaging
, qrcode
, cookiecutter
, uvicorn
, watchdog
, websocket-client
, websockets

}:

buildPythonPackage rec {
  pname = "flet";
  inherit (flet-client-flutter) version src;

  pyproject = true;

  sourceRoot = "${src.name}/sdk/python/packages/flet";

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "websockets"
    "cookiecutter"
    "watchdog"
  ];

  propagatedBuildInputs = [
    fastapi
    flet-core
    flet-runtime
    uvicorn
    websocket-client
    watchdog
    oauthlib
    websockets
    httpx
    packaging
    qrcode
    cookiecutter
    fastapi
    uvicorn
  ];

  doCheck = false;

  pythonImportsCheck = [
    "flet"
  ];

  meta = {
    description = "A framework that enables you to easily build realtime web, mobile, and desktop apps in Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heyimnova lucasew ];
    mainProgram = "flet";
  };
}
