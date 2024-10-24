{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0-unstable-2024-09-20";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "dcbe2690ce41a286ef1eed54747bac47cee6dc2c";
    hash = "sha256-XlZSVN/kTSA5X/kTpD/Hr5YBXdfh8gJPq5Da4tL0Gpk=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  cargoHash = "sha256-3OjZhWAgfmMZ0OGeRawk3KZpPqz1QCVkwsyGM+E7o88=";

  buildInputs = [
    libxkbcommon
  ];

  meta = with lib; {
    description = "Tool to freeze the screen of a Wayland compositor";
    homepage = "https://github.com/Jappie3/wayfreeze";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      purrpurrn
      jappie3 /* upstream dev */
    ];
    mainProgram = "wayfreeze";
    platforms = platforms.linux;
  };
}
