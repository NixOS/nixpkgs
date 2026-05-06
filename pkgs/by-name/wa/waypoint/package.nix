{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "waypoint";
  version = "0-unstable-2025-06-10";

  src = fetchFromGitHub {
    owner = "tadeokondrak";
    repo = "waypoint";
    rev = "bfd3a4ddf75b0be933ea8954f7db0fdb6fd22fab";
    hash = "sha256-WUsJlZAmIhKMNuQI74fyiUCLvQ321bz2vkSHJ8YVLbg=";
  };

  cargoHash = "sha256-U2xHFII0FMG9Zc+2W3JguBIXIgtfWIHWsUUDxnjoF5U=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Move and click the mouse pointer with keyboard controls";
    homepage = "https://github.com/tadeokondrak/waypoint";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "waypoint";
  };
})
