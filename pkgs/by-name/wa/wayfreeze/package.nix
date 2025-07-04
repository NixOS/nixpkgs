{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0-unstable-2025-06-29";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "57877b94804b23e725257fcf26f7c296a5a38f8c";
    hash = "sha256-dArJwfAm3jqJurNYMUOVzGMMp1ska0D+SkQ6tj0HhqQ=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  useFetchCargoVendor = true;
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
