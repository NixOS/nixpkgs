{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typst-ansi-hl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "frozolotl";
    repo = "typst-ansi-hl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WiWGZ/rndbW2jcP/rNikRVqY/+R4ScZc084RFDU0OCk=";
  };

  cargoHash = "sha256-LUUu97gxT1oy8Dr/3KgxErvy2YunlHaRta0o5YTysqM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/frozolotl/typst-ansi-hl/releases/tag/v${finalAttrs.version}";
    description = "Highlights your Typst code using ANSI escape sequences";
    homepage = "https://github.com/frozolotl/typst-ansi-hl";
    license = lib.licenses.eupl12;
    mainProgram = "typst-ansi-hl";
    maintainers = with lib.maintainers; [ andrew15-5 ];
    platforms = lib.platforms.all; # Should work on most platforms.
  };
})
