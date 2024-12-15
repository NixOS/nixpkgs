{
  darwin,
  fetchFromGitHub,
  lib,
  libiconv,
  rustPlatform,
  stdenv,
}:
let
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
  buildInputs = [
    libiconv
  ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.SystemConfiguration;
  meta = {
    description = "A command-line translator powered by Google Translate";
    longDescription = ''
      This command-line tool leverages Google Translate to translate text quickly between languages.
      It can be used to translate command-line output, allowing users to work with any language from the terminal.
    '';
    homepage = "https://github.com/NewDawn0/tl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
