{ lib
, buildPythonPackage
, fetchPypi

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
  version = "0.18.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ix9O4wBq7/gwkV+23B+dnxTYv/VL6w8RmnvbYWcWqmc=";
  };

  nativeBuildInputs = [
    poetry-core
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
