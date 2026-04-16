{
  buildPythonPackage,
  deltachat-rpc-server,
  imap-tools,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "deltachat-rpc-client";
  inherit (deltachat-rpc-server) version src;
  pyproject = true;

  sourceRoot = "${src.name}/deltachat-rpc-client";

  postPatch = ''
    substituteInPlace src/deltachat_rpc_client/rpc.py \
      --replace-fail deltachat-rpc-server "${deltachat-rpc-server.exe}"
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "deltachat_rpc_client" ];

  nativeCheckInputs = [
    imap-tools
    pytestCheckHook
  ];

  # requires a chatmail server
  doCheck = false;

  meta = {
    inherit (deltachat-rpc-server.meta) changelog license maintainers;
    description = "Python client for Delta Chat core JSON-RPC interface";
    homepage = "https://github.com/deltachat/deltachat-core-rust/tree/main/deltachat-rpc-client";
  };
}
