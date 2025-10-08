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
  pythonOlder,
  setuptools,
  siosocks,
  trustme,
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.27.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fASMMiAIF5bFmDKm/Z/Y+tl+POwSpQvjq8zy3LvrJho=";
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
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # uses 127.0.0.2, which macos doesn't like
    "test_pasv_connection_pasv_forced_response_address"
  ];

  pythonImportsCheck = [ "aioftp" ];

  meta = with lib; {
    description = "Python FTP client/server for asyncio";
    homepage = "https://aioftp.readthedocs.io/";
    changelog = "https://github.com/aio-libs/aioftp/blob/${version}/history.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
