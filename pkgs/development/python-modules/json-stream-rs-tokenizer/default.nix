{ lib
<<<<<<< HEAD
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
=======
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, cargo
, rustc
, setuptools-rust
, json-stream-rs-tokenizer
, json-stream
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "json-stream-rs-tokenizer";
<<<<<<< HEAD
  version = "0.4.22";
=======
  version = "0.4.16";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "smheidrich";
    repo = "py-json-stream-rs-tokenizer";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
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
=======
    hash = "sha256-MnYkCAI8x65kU0EoTRf4ZVsbjNravjokepX4yViu7go=";
  };

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src postPatch;
    name = "${pname}-${version}";
    hash = "sha256-HwWH8/UWKWOdRmyCVQtNqJxXD55f6zxLY0LhR7JU9ro=";
  };

  nativeBuildInputs = [
    setuptools-rust
    rustPlatform.cargoSetupHook
    cargo
    rustc
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
