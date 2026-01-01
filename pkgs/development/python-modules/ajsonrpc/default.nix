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

<<<<<<< HEAD
  meta = {
    description = "Async JSON-RPC 2.0 protocol and asyncio server";
    homepage = "https://github.com/pavlov99/ajsonrpc";
    changelog = "https://github.com/pavlov99/ajsonrpc/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
=======
  meta = with lib; {
    description = "Async JSON-RPC 2.0 protocol and asyncio server";
    homepage = "https://github.com/pavlov99/ajsonrpc";
    changelog = "https://github.com/pavlov99/ajsonrpc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "async-json-rpc-server";
  };
}
