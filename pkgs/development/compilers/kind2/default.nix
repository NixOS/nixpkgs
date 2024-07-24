{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "kind2";
  version = "0.3.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-X2sjfYrSSym289jDJV3hNmcwyQCMnrabmGCUKD5wfdY=";
  };

  cargoHash = "sha256-KzoEh/kMKsHx9K3t1/uQZ7fdsZEM+v8UOft8JjEB1Zw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ];

  # requires nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "Functional programming language and proof assistant";
    mainProgram = "kind2";
    homepage = "https://github.com/higherorderco/kind";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
