{
  lib,
  rustPlatform,
  fetchFromGitLab,
  python3,
  unstableGitUpdater,
  rustfmt,
}:
rustPlatform.buildRustPackage {
  pname = "windowtolayer";
  version = "0-unstable-2025-01-26";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "windowtolayer";
    rev = "5ddb3a2834c834af4ec412bb2ba2c77431953d51";
    hash = "sha256-PzKx8lkWDJGVj1Azc/vfbSPYV7x5+ZnCGMAAK4o207Y=";
  };

  cargoHash = "sha256-XuSlbBLWUkPsA0DYC4qemvAGyynkkuznA5FGBKRmNso=";

  nativeBuildInputs = [
    python3
    rustfmt
  ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.freedesktop.org/mstoeckl/windowtolayer.git";
  };

  meta = {
    description = "Display existing Wayland applications as a wallpaper instead";
    homepage = "https://gitlab.freedesktop.org/mstoeckl/windowtolayer";
    mainProgram = "windowtolayer";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
