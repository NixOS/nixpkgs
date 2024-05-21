{ lib
, stdenv
, buildPythonPackage
, cargo
, libiconv
, fetchFromGitHub
, json-stream
, json-stream-rs-tokenizer
, pythonOlder
, rustc
, rustPlatform
, setuptools
, setuptools-rust
, wheel
}:

buildPythonPackage rec {
  pname = "json-stream-rs-tokenizer";
  version = "0.4.25";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "smheidrich";
    repo = "py-json-stream-rs-tokenizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-zo/jRAWSwcOnO8eU4KhDNz44P6xDGcrZf9CflwsSvF0=";
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
    libiconv
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
