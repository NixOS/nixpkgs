{
  darwin,
  fetchFromGitHub,
  lib,
  libiconv,
  rustPlatform,
  stdenv,
}:
rustPlatform.buildRustPackage {
  pname = "tl";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "tl";
    rev = "v1.0.0";
    sha256 = "sha256-6oKz68UIRLRB7l5Am9+GNHswJKIrV/31dhkLRPC6dhE=";
  };
  cargoHash = "sha256-QEEqkcsJulZtMpVZXqy5D187nA+ksRya8ggPB9YWILU=";
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
