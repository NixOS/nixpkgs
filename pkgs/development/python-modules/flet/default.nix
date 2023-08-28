{ lib
, buildPythonPackage

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

, flet-client-flutter
}:

buildPythonPackage rec {
  pname = "flet";
  version = "0.7.4";
  format = "pyproject";

  inherit (flet-client-flutter) src;
  sourceRoot = "source/sdk/python/packages/flet";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = "^0.23' 'httpx = ">=0.23' \
      --replace 'watchdog = "^2' 'watchdog = ">=2'
  '';

  postFixup = ''
    wrapProgram $out/bin/flet \
      --prefix PYTHONPATH : $PYTHONPATH
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

  pythonImportsCheck = [ "flet" ];

  meta = {
    description = "A framework that enables you to easily build realtime web, mobile, and desktop apps in Python";
    homepage = "https://flet.dev/";
    changelog = "https://github.com/flet-dev/flet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ heyimnova lucasew ];
    mainProgram = "flet";
  };
}
