{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  flit,
  uritemplate,
  pyjwt,
  pytestCheckHook,
  aiohttp,
  httpx,
  importlib-resources,
  pytest-asyncio,
  pytest-tornasync,
  cacert,
}:

buildPythonPackage rec {
  pname = "gidgethub";
  version = "5.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ns59N/vOuBm4BWDn7Vj5NuSKZdN+xfVtt5FFFWtCaiU=";
  };

  nativeBuildInputs = [ flit ];

  propagatedBuildInputs = [
    uritemplate
    pyjwt
  ] ++ pyjwt.optional-dependencies.crypto;

  nativeCheckInputs = [
    pytestCheckHook
    aiohttp
    httpx
    importlib-resources
    pytest-asyncio
    pytest-tornasync
  ];

  # httpx 0.28+
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  disabledTests = [
    # Require internet connection
    "test__request"
    "test_get"
  ];

  meta = with lib; {
    description = "Async GitHub API library";
    homepage = "https://github.com/brettcannon/gidgethub";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
