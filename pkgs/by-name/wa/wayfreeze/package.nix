{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0.1.0-unstable-2025-10-27";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "074d7dcc615d80e0c9e245e67fac5f90156f5791";
    hash = "sha256-fbH/jEoW8QdPgo06QJHbYeovqDi4Ku2hVDfDUp/5GU4=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  cargoHash = "sha256-uzTT4WyR7kCL/HPu7JHGQqG9tbO1JGIW1Jtlza5lhPk=";

  buildInputs = [
    libxkbcommon
  ];

  meta = with lib; {
    description = "Tool to freeze the screen of a Wayland compositor";
    homepage = "https://github.com/Jappie3/wayfreeze";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      purrpurrn
      jappie3 # upstream dev
    ];
    mainProgram = "wayfreeze";
    platforms = platforms.linux;
  };
}
