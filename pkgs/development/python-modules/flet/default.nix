{ lib
, python3
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "flet";
  version = "0.7.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vFPjN+5wIygtP035odAOSdF9PQe6eXz6CJ9Q0d8ScFo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = "^0.23' 'httpx = ">=0.23' \
      --replace 'watchdog = "^2' 'watchdog = ">=2'
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
