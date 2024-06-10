{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0-unstable-2024-05-23";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "069dea0b832bd5b7a7872a57bd53f51cd377f206";
    hash = "sha256-3btFzZbkHT6kBBA3M7OwFsD710VpMiHSXIpHmvCD/es=";
  };

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
