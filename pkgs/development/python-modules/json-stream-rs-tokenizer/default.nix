{ lib
, stdenv
, buildPythonPackage
, cargo
, darwin
, fetchFromGitHub
, json-stream
, json-stream-rs-tokenizer
, rustc
, rustPlatform
, setuptools
, setuptools-rust
, wheel
}:

buildPythonPackage rec {
  pname = "json-stream-rs-tokenizer";
  version = "0.4.22";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "smheidrich";
    repo = "py-json-stream-rs-tokenizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-EW726gUXTBX3gTxlFQ45RgkUa2Z4tIjUZxO4GBLXgEs=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "utf8-read-0.4.0" = "sha256-L/NcgbB+2Rwtc+1e39fQh1D9S4RqQY6CCFOTh8CI8Ts=";
    };
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    setuptools
    setuptools-rust
    wheel
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.libiconv
  ];

  # Tests depend on json-stream, which depends on this package.
  # To avoid infinite recursion, we only enable tests when building passthru.tests.
  doCheck = false;

  checkInputs = [
    json-stream
  ];

  pythonImportsCheck = [
    "json_stream_rs_tokenizer"
  ];

  passthru.tests = {
    runTests = json-stream-rs-tokenizer.overrideAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    description = "A faster tokenizer for the json-stream Python library";
    homepage = "https://github.com/smheidrich/py-json-stream-rs-tokenizer";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
  };
}
