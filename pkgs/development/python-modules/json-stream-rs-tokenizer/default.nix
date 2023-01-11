{ lib
, buildPythonPackage
, fetchFromGitHub
, rustPlatform
, setuptools-rust
, json-stream-rs-tokenizer
, json-stream
}:

buildPythonPackage rec {
  pname = "json-stream-rs-tokenizer";
  version = "0.4.13";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "smheidrich";
    repo = "py-json-stream-rs-tokenizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-9pJi80V7WKvsgtp0ffItWnjoOvFvfE/Sz6y2VlsU+wQ=";
  };

  postPatch = ''
    cp ${./Cargo.lock} ./Cargo.lock
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src postPatch;
    name = "${pname}-${version}";
    hash = "sha256-TjRdHSXHmF6fzCshX1I4Sq+A/fEmBHDPGZvJUxL13aM=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

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
