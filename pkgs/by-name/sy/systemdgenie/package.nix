{
  stdenv,
  lib,
  cmake,
  fetchFromGitLab,
  kdePackages,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "systemdgenie";
  version = "0.99.0-unstable-2025-11-24";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "SystemdGenie";
    owner = "system";
    rev = "7fe75b62e92f3fbb3940b14be946f9956a2cdb05";
    hash = "sha256-Wbvm9nsCtjO8Jpj2gRi1jsK/GybSC8gLTqpcD6yAgv4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kirigami-addons
    kdePackages.kio
    kdePackages.ktexteditor
    kdePackages.kxmlgui
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Systemd management utility";
    mainProgram = "systemdgenie";
    homepage = "https://kde.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.pasqui23 ];
    platforms = lib.platforms.linux;
  };
}
