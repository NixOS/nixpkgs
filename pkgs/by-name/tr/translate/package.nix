{
  darwin,
  fetchFromGitHub,
  lib,
  libiconv,
  rustPlatform,
  stdenv,
}: let
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "tl";
    rev = "2e104c44e7afeda9d310acbcad1abb6f2571179a";
    sha256 = "sha256-WFTB2cQxR8wvdwSzA1yLkEjahrjUWXcJy7tkpRjerBQ=";
  };
in
  rustPlatform.buildRustPackage {
    pname = "tl";
    version = "1.0.0";
    inherit src;

    cargoLock.lockFile = "${src}/Cargo.lock";
    buildInputs =
      [libiconv]
      ++ lib.optional stdenv.hostPlatform.isDarwin
      darwin.apple_sdk.frameworks.SystemConfiguration;

    meta = with lib; {
      description = "A cli translator using Google Translate";
      homepage = "https://github.com/NewDawn0/tl";
      license = licenses.mit;
      maintainers = with maintainers; [NewDawn0];
    };
  }
