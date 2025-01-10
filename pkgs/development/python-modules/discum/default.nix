{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonRelaxDepsHook,
  brotli,
  colorama,
  filetype,
  requests,
  requests-toolbelt,
  ua-parser,
  websocket-client,
  pycryptodome,
  pypng,
  pyqrcode,
}:

buildPythonPackage rec {
  pname = "discum";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/8TaAmfSPv/7kuymockSvC2uxXgHfuP+FXN8vuA9WHY=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  dependencies = [
    brotli
    colorama
    filetype
    requests
    requests-toolbelt
    ua-parser
    websocket-client
  ];

  passthru.optional-dependencies = {
    ra = [
      pycryptodome
      pypng
      pyqrcode
    ];
  };

  pythonImportsCheck = [ "discum" ];

  pythonRelaxDeps = [ "websocket-client" ];

  meta = {
    description = "Discord API Wrapper for Userbots/Selfbots written in Python";
    homepage = "https://pypi.org/project/discum/";
    changelog = "https://github.com/Merubokkusu/Discord-S.C.U.M/blob/v${version}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
}
