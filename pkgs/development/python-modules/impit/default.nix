{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  rustc,
  perl,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "impit";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apify";
    repo = "impit";
    tag = "py-${version}";
    hash = "sha256-2PNxobTMFaxJCPKb8YFR576r3uzWpymDw6UF5xGj2OA=";
  };

  buildAndTestSubdir = "impit-python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-LH3cDn16VWSNk8xYk7l5AvnmoMk3dgdi+LSjq6vcAns=";
  };

  # The `http3` feature used by reqwest is unstable and requires this flag.
  env.RUSTFLAGS = "--cfg reqwest_unstable";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    cargo
    rustc
    perl # for openssl
  ];

  pythonImportsCheck = [ "impit" ];

  nativeCheckInputs = [
    pytestCheckHook
    # Reduce number of failed async_client_test.py tests,
    # but still persists for some and for response_test.py
    # pytest-asyncio
  ];

  # Disable tests that fail in the sandboxed build environment.
  # - async_client_test.py: Both infra. errors.
  # - basic_client_test.py: Fails with "impit.ConnectError: Failed to connect to the server" due to network restrictions.
  # - response_test.py (test_setattr): Fail with "Failed: async def functions are not natively supported".
  disabledTests = [
    "async_client_test"
    "basic_client_test"
    "test_setattr"
  ];

  meta = {
    description = "HTTP client with automatic browser fingerprint generation";
    homepage = "https://github.com/apify/impit";
    changelog = "https://github.com/apify/impit/releases/tag/${src.tag}";
    licenses = lib.licenses.asl20;
    maintainers = [ lib.maintainers.monk3yd ];
  };
}
