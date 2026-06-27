{
  lib,
  rustPlatform,
  fetchFromGitLab,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "worm-hole";
  version = "4.0.1";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "Rignchen";
    repo = "worm_hole";
    tag = finalAttrs.version;
    hash = "sha256-G19bHpHpyMAGJQ9JIKBXTJDEo+UU1mRWlNTmmSUNRWo=";
  };

  cargoHash = "sha256-Yo/vAO4rCPNKmVT8cxO7VjBvr3M8iYxPQanlJVc+e3E=";

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
