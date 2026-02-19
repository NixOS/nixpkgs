{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayshot";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "wayshot";
    rev = finalAttrs.version;
    hash = "sha256-nUpIN4WTePtFZTmKAjv0tgj4VTdZeXjoQX6am9+M3ig=";
  };

  cargoHash = "sha256-uKETDGi1n6VcdGCrjrnEM1sQ0vVjd/vCXMUn9Hby2m8=";

  # tests are off as they are broken and pr for integration testing is still WIP
  doCheck = false;

  meta = {
    description = "Native, blazing-fast screenshot tool for wlroots based compositors such as sway and river";
    homepage = "https://github.com/waycrate/wayshot";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      dit7ya
      id3v1669
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wayshot";
  };
})
