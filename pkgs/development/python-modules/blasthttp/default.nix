{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  fetchPypi,
  nix-update-script,
  openssl,
  pkg-config,
  pytest-asyncio,
  pytestCheckHook,
  rustc,
  rustPlatform,
}:

buildPythonPackage (finalAttrs: {
  pname = "blasthttp";
  version = "0.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-SA8tEo9Zd56laeiu3e5lw+thP7g2SWgolqJ7znTSuzk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-Im1/ews/hPh3dcub80m2k1RICD/5Jfnl+e/VM1Btk44=";
  };

  postPatch = ''
    # The bundled .cargo/config.toml sets OPENSSL_DIR to a relative path
    rm .cargo/config.toml
  '';

  __darwinAllowLocalNetworking = true;

  env = {
    OPENSSL_NO_VENDOR = "1";
  };

  build-system = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [
    openssl
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "blasthttp" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    "tests/python/test_ssl_verify.py"
    "tests/python/test_response_api.py"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_redirect_onto_proxied_host_reevaluates_no_proxy"
    "test_redirect_onto_no_proxy_host_reevaluates_to_direct"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offensive-first HTTP library";
    homepage = "https://pypi.org/project/blasthttp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
