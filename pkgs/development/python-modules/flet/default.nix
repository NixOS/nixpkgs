{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook

# build-system
, poetry-core

# propagates
, flet-core
, flet-runtime
, httpx
, oauthlib
, packaging
, qrcode
, cookiecutter
, watchdog
, websocket-client
, websockets

}:

buildPythonPackage rec {
  pname = "flet";
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YpML/NIUiL1WYg6zR6l60nJ6KRBfjMOjRbPDdjhR3/Q=";
  };

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "websockets"
  ];

  propagatedBuildInputs = [
    flet-core
    flet-runtime
    websocket-client
    watchdog
    oauthlib
    websockets
    httpx
    packaging
    qrcode
    cookiecutter
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
    maintainers = [ lib.maintainers.heyimnova ];
    mainProgram = "flet";
  };
}
