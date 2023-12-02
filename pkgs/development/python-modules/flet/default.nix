{ lib
, buildPythonPackage
, fetchPypi

# build-system
, poetry-core

# propagates
, flet-core
, httpx
, oauthlib
, packaging
, typing-extensions
, watchdog
, websocket-client
, websockets

}:

buildPythonPackage rec {
  pname = "flet";
  version = "0.14.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3QN1zGZ1AFxO53RHAEk1JoJoE0FKVWYCiNo2/DdREfA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = "^0.23' 'httpx = ">=0.23' \
      --replace 'watchdog = "^2' 'watchdog = ">=2'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    flet-core
    typing-extensions
    websocket-client
    watchdog
    oauthlib
    websockets
    httpx
    packaging
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
