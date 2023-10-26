{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config
, openssl, libiconv, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trunk-ng";
  version = "0.17.10";

  src = fetchFromGitHub {
    owner = "ctron";
    repo = "trunk";
    rev = "v${version}";
    hash = "sha256-F2g/GMxnS5r44i3NIJGOic9f+H5+JbFi3dqMqI6h6JQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = if stdenv.isDarwin
    then [ libiconv CoreServices Security ]
    else [ openssl ];

  # requires network
  checkFlags = [ "--skip=tools::tests::download_and_install_binaries" ];

  cargoHash = "sha256-37nCqRTgbsg2cXu4xwYC/qfodPIxx97Qns8FQe9NroQ=";

  meta = with lib; {
    homepage = "https://github.com/ctron/trunk";
    description = "Build, bundle & ship your Rust WASM application to the web";
    maintainers = with maintainers; [ ctron ];
    license = with licenses; [ asl20 ];
  };
}
