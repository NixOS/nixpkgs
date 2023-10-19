{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk-ng";
  version = "0.17.8";

  src = fetchFromGitHub {
    owner = "ctron";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-ycZIqDBZccPapOK0ZI9Cvq94tRxChrsWX1rhyWh0S2c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-URHArTog34JcuxXHzTQBjQOFMffarNb51d9sUOfjm6c=";

  meta = with lib; {
    homepage = "https://github.com/ctron/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ ctron ];
    license = with licenses; [ asl20 ];
  };
}
