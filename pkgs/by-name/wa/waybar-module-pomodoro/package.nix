{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage {
  pname = "waybar-module-pomodoro";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "Andeskjerf";
    repo = "waybar-module-pomodoro";
    rev = "3d42cbd69edce0b82ff79d64e1981328f2e86842";
    hash = "sha256-BF7JqDIVDLX66VE/yKmb758rXnfb1rv/4hwzf3i0v5g=";
  };

  cargoHash = "sha256-N1xuKml9cRDix0SOVBKJydTN35EKk+ohnXhInsMG3HY=";

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Pomodoro timer intended for Waybar";
    homepage = "https://github.com/Andeskjerf/waybar-module-pomodoro";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      zencrab
    ];
    mainProgram = "waybar-module-pomodoro";
  };
}
