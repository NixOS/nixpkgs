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
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "windowtolayer";
    tag = "v${version}";
    hash = "sha256-zoe0rrjoS3h/MnQhUVCRTIifRMUN7JZmdgQ/8cRapJk=";
  };

  cargoHash = "sha256-Y+8v7Q9vs3f5MttFED9Ym6+WS1W0RcPTpDMKcESNRtY=";

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
