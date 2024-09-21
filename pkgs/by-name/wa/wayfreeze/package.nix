{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  unstableGitUpdater,
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

  passthru.updateScript = unstableGitUpdater { };

  cargoHash = "sha256-3OjZhWAgfmMZ0OGeRawk3KZpPqz1QCVkwsyGM+E7o88=";

  buildInputs = [
    libxkbcommon
  ];

  meta = with lib; {
    description = "Tool to freeze the screen of a Wayland compositor";
    homepage = "https://github.com/Jappie3/wayfreeze";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [ purrpurrn ];
    mainProgram = "wayfreeze";
    platforms = platforms.linux;
  };
}
