{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "kind2";
  version = "0.3.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-ZG0BbGcjQBqeNTqfy7WweVHK7sUuKeQSsFi9KIsyIE4=";
  };

  cargoSha256 = "sha256-j64L3HNk2r+MH9eDHWT/ARJ9DT4CchcuVxtIYYVsDxo=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Security
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    darwin.apple_sdk_11_0.frameworks.CoreFoundation
  ];

  # requires nightly features
  RUSTC_BOOTSTRAP = true;

  meta = with lib; {
    description = "A functional programming language and proof assistant";
    homepage = "https://github.com/kindelia/kind";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
