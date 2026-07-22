{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  dacite,
  deltachat-rpc-server,
  setuptools-scm,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "deltachat2";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat2";
    tag = version;
    hash = "sha256-L2T1dUv7OCkAg6R5W1ukT/jEcSIkoLUVZmBhYxuPDCE=";
  };

  patches = [
    (replaceVars ./paths.patch {
      deltachatrpcserver = lib.getExe deltachat-rpc-server;
    })
  ];

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    dacite
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
