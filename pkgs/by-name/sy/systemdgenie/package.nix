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
  version = "0.99.0-unstable-2025-11-18";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "SystemdGenie";
    owner = "system";
    rev = "68c658c684f2e2bd519002b143773c671b0b044e";
    hash = "sha256-Vc/RmpMGIKZCiKCgxZpTI+WbTcuuvoUicpzCHXNZvcQ=";
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
