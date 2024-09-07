{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ajsonrpc";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eRusGPC/De4QkZRkTxUc+Lf/UpxLjWI5rEgQSjJRoZ8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ajsonrpc" ];

  meta = with lib; {
    description = "Async JSON-RPC 2.0 protocol and asyncio server";
    homepage = "https://github.com/pavlov99/ajsonrpc";
    changelog = "https://github.com/pavlov99/ajsonrpc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
    mainProgram = "async-json-rpc-server";
  };
}
