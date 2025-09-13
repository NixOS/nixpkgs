{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "waybar-module-pomodoro";
  version = "0-unstable-2025-07-28";

  src = fetchFromGitHub {
    owner = "Andeskjerf";
    repo = "waybar-module-pomodoro";
    rev = "b5e5d9b83906bd3a40f4c1d118cdb1d40884a9ad";
    hash = "sha256-BF7JqDIVDLX66VE/yKmb758rXnfb1rv/4hwzf3i0v5g=";
  };

  cargoHash = "sha256-N1xuKml9cRDix0SOVBKJydTN35EKk+ohnXhInsMG3HY=";

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Pomodoro timer intended for Waybar";
    homepage = "https://github.com/Andeskjerf/waybar-module-pomodoro";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.parrot7483 ];
  };
})
