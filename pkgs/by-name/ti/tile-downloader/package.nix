{
  lib,
  rustPlatform,
  fetchFromGitLab,
  nix-update-script,
  openssl,
  pkg-config,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tile-downloader";
  version = "0.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.scd31.com";
    owner = "stephen";
    repo = "tile-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+FnLGMUGyuaN7uPRvuounDKwF6pV9NKv3r/ajdKtdCE=";
  };

  cargoHash = "sha256-jKNp+YJKZ3qpaDzwi3DvFaZAipRhm1+sTtKBtQEj7qI=";

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Multi-threaded raster tile downloader, primarily designed for downloading OSM tiles for usage offline";
    mainProgram = "tile-downloader";
    homepage = "https://gitlab.scd31.com/stephen/tile-downloader";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scd31 ];
  };
})
