{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  pkg-config,
  nix-update-script,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "workset";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "workset";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ryi5zLlOVNVtHhMZ5PglNFKVrrSlrcj3TOoeHKjGAic=";
  };

  cargoHash = "sha256-VJ1vXEZkOYUGba8hfgdlNpT0QAvHDPdR+TNhDNprKNk=";

  nativeBuildInputs = [ pkg-config ];

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "workset";
    description = "Manage git repos with working sets";
    homepage = "https://github.com/fossable/workset";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
