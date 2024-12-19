{
  lib,
  stdenv,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  siosocks,
  trustme,
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.24.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dKx8buSFXk24/6LC+xWXeJppeBfEe6IaVOuQOfQ1aK8=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    socks = [ siosocks ];
  };

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    trustme
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # uses 127.0.0.2, which macos doesn't like
    "test_pasv_connection_pasv_forced_response_address"
  ];

  pythonImportsCheck = [ "aioftp" ];

  meta = with lib; {
    description = "Python FTP client/server for asyncio";
    homepage = "https://aioftp.readthedocs.io/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
