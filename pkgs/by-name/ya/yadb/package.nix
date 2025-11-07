{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yadb";
  version = "0.3.4";
  src = fetchFromGitHub {
    owner = "izya4ka";
    repo = "yadb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kIqVPzYvmj9JXQ06GRkS1sxJJ6DTex6BPK6JK9oMmhI=";
  };
  cargoHash = "sha256-HlXZkmdgglSvmzCUIeUYCj/sc15OBOzio3V7fU4Uk9s=";
  nativeBuildInputs = [
    pkg-config
  ];
  passthru.updateScript = nix-update-script { };
  meta = {
    changelog = "https://github.com/izya4ka/yadb/releases/tag/v${finalAttrs.version}";
    description = "Directory brute-forcing tool written in Rust, inspired by gobuster";
    homepage = "https://github.com/izya4ka/yadb";
    license = lib.licenses.gpl3Plus;
    mainProgram = "yadb-cli";
    maintainers = with lib.maintainers; [ linuxmobile ];
    platforms = lib.platforms.linux;
  };
})
