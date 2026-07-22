{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worm-hole";
  version = "4.1.1";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "Rignchen";
    repo = "worm_hole";
    tag = finalAttrs.version;
    hash = "sha256-f8+PYPWzVMtBovgComgpKaibQhbxhmQjK6RKFpWU0CA=";
  };

  cargoHash = "sha256-fCREYEFLkotyzaMv/ki/0Ht/TS1aXryaE5fapC3F5qs=";

  meta = {
    description = "CLI tool to easily jump between directories";
    homepage = "https://gitlab.com/Rignchen/worm_hole";
    changelog = "https://gitlab.com/Rignchen/worm_hole/-/releases/${finalAttrs.src.tag}";
    mainProgram = "worm_hole";
    maintainers = with lib.maintainers; [ rignchen ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
