{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wayfreeze";
  version = "0-unstable-2024-12-26";

  src = fetchFromGitHub {
    owner = "Jappie3";
    repo = "wayfreeze";
    rev = "5f7b7f50b69962b41a685c82fc9e82370d02275a";
    hash = "sha256-ARnA0R5wZqHDIY+0le0F9okpJS4OI9XpLjN3vsmqUkY=";
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
