{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonrpc-base";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emlove";
    repo = "jsonrpc-base";
    tag = version;
    hash = "sha256-AbpuAW+wuGc+Vj4FDFlyB2YbiwDxPLuyAGiNcmGU+Ss=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "jsonrpc_base" ];

  meta = {
    description = "JSON-RPC client library base interface";
    homepage = "https://github.com/emlove/jsonrpc-base";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
