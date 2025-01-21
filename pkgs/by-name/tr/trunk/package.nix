{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "trunk";
  version = "0.21.6";

  src = fetchFromGitHub {
    owner = "trunk-rs";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-DpisuwuuZqOPcjlU6F1CfmSUo9+KcibX3nI0rII4ohg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];
  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-QCo+lCgVsVIT18elDcbeqppIqbdbMlVGoAuEPehoGM4=";

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
