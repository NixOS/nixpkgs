{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  deltachat-rpc-server,
  setuptools-scm,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "deltachat2";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat2";
    tag = version;
    hash = "sha256-n40LyF73FxXXIJnNwVG9B6ibUYaHbx6t9MRPdMjSInw=";
  };

  patches = [
    (replaceVars ./paths.patch {
      deltachatrpcserver = lib.getExe deltachat-rpc-server;
    })
  ];

  build-system = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "deltachat2" ];

  meta = {
    description = "Client library for Delta Chat core JSON-RPC interface";
    homepage = "https://github.com/adbenitez/deltachat2";
    license = lib.licenses.mpl20;
    mainProgram = "deltachat2";
    inherit (deltachat-rpc-server.meta) maintainers;
  };
}
