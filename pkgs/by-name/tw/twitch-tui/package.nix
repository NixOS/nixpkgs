{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "twitch-tui";
  version = "2.6.19";

  src = fetchFromGitHub {
    owner = "Xithrius";
    repo = "twitch-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hA66YcxbQem9ymOu3tGA4biKUCoJ2jKnUSK+9+0P2Eg=";
  };

  cargoHash = "sha256-DMUE3sTJEz2AxUctnjm0CkvOqMeAw5urLPZkkHvf9A8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Twitch chat in the terminal";
    homepage = "https://github.com/Xithrius/twitch-tui";
    changelog = "https://github.com/Xithrius/twitch-tui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.lordmzte ];
    mainProgram = "twt";
  };
})
