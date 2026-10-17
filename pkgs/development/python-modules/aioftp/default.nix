{
  lib,
  stdenv,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  setuptools,
  siosocks,
  trustme,
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.28.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MR9m6f9yYFX3PnR2T7YuCXq4Btoxd8E/E1bI5+r5pl0=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    socks = [ siosocks ];
  };

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    trustme
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # uses 127.0.0.2, which macos doesn't like
    "test_pasv_connection_pasv_forced_response_address"
  ];

  pythonImportsCheck = [ "aioftp" ];

  meta = {
    description = "Python FTP client/server for asyncio";
    homepage = "https://aioftp.readthedocs.io/";
    changelog = "https://github.com/aio-libs/aioftp/blob/${version}/history.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
