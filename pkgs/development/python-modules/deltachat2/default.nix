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
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat2";
    tag = version;
    hash = "sha256-04MXh1p2xRRnvyu5GrPqMuaraP08WQbFzXYhkXRznA4=";
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
