{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, cargo
, darwin
, rustc
, setuptools-rust
, json-stream-rs-tokenizer
, json-stream
}:

buildPythonPackage rec {
  pname = "json-stream-rs-tokenizer";
  version = "0.4.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "smheidrich";
    repo = "py-json-stream-rs-tokenizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-MnYkCAI8x65kU0EoTRf4ZVsbjNravjokepX4yViu7go=";
  };

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "pyo3-file-0.5.0" = "sha256-QsxygdANnYyIH9L/kpL+yH2pwvgwnRCCSFPaOQ/z8sA=";
    };
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
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
