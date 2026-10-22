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
  version = "0.3.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "windowtolayer";
    tag = "v${version}";
    hash = "sha256-TUet9DqLMsY34Mb9t4IKr3Z/JxrPgvufzanHI4D9dZg=";
  };

  cargoHash = "sha256-MqcutNzorDeYoGKWFbCzIrNuo1w2vwnGEFOuooZwPgk=";

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
