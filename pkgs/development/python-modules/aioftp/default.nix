{
  lib,
  stdenv,
  async-timeout,
  buildPythonPackage,
  fetchPypi,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  siosocks,
  trustme,
}:

buildPythonPackage rec {
  pname = "aioftp";
  version = "0.22.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uqKxMYaqAWIuS4LyfC9I9Nr7SORXprGPzamakl4NwnA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ siosocks ];

  passthru.optional-dependencies = {
    socks = [ siosocks ];
  };

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytestCheckHook
    trustme
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = lib.optionals stdenv.isDarwin [
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
