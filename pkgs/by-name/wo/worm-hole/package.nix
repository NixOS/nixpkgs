{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worm-hole";
  version = "4.1.0";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "Rignchen";
    repo = "worm_hole";
    tag = finalAttrs.version;
    hash = "sha256-9UYugWBKBWEjTrWkyOYTB9/0OF8xGTtbjU1Rqsu9vv4=";
  };

  cargoHash = "sha256-2bfcyDy9CW/pYWgcIdaWHKgU/ms+xgxa+5njxK7AyrM=";

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
