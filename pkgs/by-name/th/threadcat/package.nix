{
  lib,
  fetchFromCodeberg,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "threadcat";
  version = "0.1.2";

  src = fetchFromCodeberg {
    owner = "blinry";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-AbdxEgnUM5iqFTKrMK2FnFWvELk46PEEWSVAlv1MBzQ=";
  };

  cargoHash = "sha256-F46gEUWcKl1nFS1faXeWJLV0lmCrJhBN3XpOiTcGXEc=";

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "Converts a Mastodon thread to Markdown, and downloads all contained media files";
    homepage = "https://codeberg.org/blinry/threadcat";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.aiyion ];
    mainProgram = "threadcat";
  };
})
