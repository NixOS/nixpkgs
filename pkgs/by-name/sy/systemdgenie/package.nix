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
  version = "0.99.0-unstable-2025-12-20";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "SystemdGenie";
    owner = "system";
    rev = "8b9fd771cfcae09855fd3e4a0e9a7dc284e64a54";
    hash = "sha256-UspdDKdrf2EPMOdx9tm98qTWpRv8vMKAQ16dX/EZdOY=";
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
