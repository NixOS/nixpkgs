{
  lib,
  rustPlatform,
  fetchFromGitLab,
  python3,
  rustfmt,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "windowtolayer";
  version = "0.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "windowtolayer";
    tag = "v${version}";
    hash = "sha256-bqHdfBXJWoKr1xdR7qPZcc9fGVlLwoopLbtn6F+EtqY=";
  };

  cargoHash = "sha256-g1oFkowKWg2xjd7+fG8EuMvDiy/r2/Nu38RIb4X6X2I=";

  nativeBuildInputs = [
    python3
    rustfmt
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display existing Wayland applications as a wallpaper instead";
    homepage = "https://gitlab.freedesktop.org/mstoeckl/windowtolayer";
    mainProgram = "windowtolayer";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ freebsd;
    maintainers = with lib.maintainers; [ anomalocaris ];
  };
}
