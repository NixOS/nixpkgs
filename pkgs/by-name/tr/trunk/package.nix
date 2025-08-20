{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.5";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-AHW686xPGCMLISrOLLfDR5g+2XpMJ+zfmWGn3fMfKbA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-m09ZV0Z4bNyAfO6XNiDKyqMeqv2/tx4vpQnWlesCW2A=";

  meta = with lib; {
    homepage = "https://github.com/trunk-rs/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    mainProgram = "trunk";
    maintainers = with maintainers; [
      freezeboy
      ctron
    ];
    license = with licenses; [ asl20 ];
  };
}
