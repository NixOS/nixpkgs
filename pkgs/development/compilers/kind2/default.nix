{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "kind2";
  version = "0.3.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-X2sjfYrSSym289jDJV3hNmcwyQCMnrabmGCUKD5wfdY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-G6UW8m/6D+hgRRceMPYFI+k4D7Ui6sDUDzI5IVWvVyc=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace-fail "#![feature(panic_info_message)]" ""
    substituteInPlace src/main.rs \
      --replace-fail "e.message().unwrap()" "e.payload()"
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
