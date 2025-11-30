{
  lib,
  stdenv,
  buildPythonPackage,
  cargo,
  libiconv,
  fetchFromGitHub,
  json-stream,
  json-stream-rs-tokenizer,
  pythonOlder,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  wheel,
}:

buildPythonPackage rec {
  pname = "json-stream-rs-tokenizer";
  version = "0.4.31";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "smheidrich";
    repo = "py-json-stream-rs-tokenizer";
    tag = "v${version}";
    hash = "sha256-n+ZPB1BGUHEanpLpe4ZO6LjbxTALJ4Ns9/Hn7nE3mpc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-IPQrqayhyQ/gmT6nK+TgDcUQ4mPrG9yiJJk6enBzybA=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
    setuptools-rust
    wheel
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  # Tests depend on json-stream, which depends on this package.
  # To avoid infinite recursion, we only enable tests when building passthru.tests.
  doCheck = false;

  checkInputs = [ json-stream ];

  pythonImportsCheck = [ "json_stream_rs_tokenizer" ];

  passthru.tests = {
    runTests = json-stream-rs-tokenizer.overrideAttrs (_: {
      doCheck = true;
    });
  };

  meta = with lib; {
    description = "Faster tokenizer for the json-stream Python library";
    homepage = "https://github.com/smheidrich/py-json-stream-rs-tokenizer";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
  };
}
