{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  deltachat-rpc-server,
  setuptools-scm,
  substituteAll,
}:

buildPythonPackage rec {
  pname = "deltachat2";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat2";
    rev = "refs/tags/${version}";
    hash = "sha256-bp4bi+EeMaWP8zOaPp0eaPKn71F055QgMOOSDzIJUH4=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
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
