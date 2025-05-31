{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0-unstable-2025-03-18";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "8277f981b4aace2a8411b39e2fbd4e15ad211078";
    hash = "sha256-3lYBzVO1Nssq/uxbZsop7v45yQ+mZs8QhfTMB6XoTzM=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jA+hVVV2hM/Hw/9rzGM63UuT/aq488kTMC/AKwSmoJk=";

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
