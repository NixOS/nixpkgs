{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  kdePackages,
  qt6,
  SDL2,
  versionCheckHook,
  umu-launcher,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vermouth";
  version = "2.0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dekomote";
    repo = "vermouth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lRqXvp5PO+0tl7PxJZ/7TET1mZgv8A/E2lTQD+0K0Hc=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qtbase
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative

    kdePackages.extra-cmake-modules
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kirigami
    kdePackages.qqc2-desktop-style

    SDL2
  ];

  preFixup = ''
    patchelf --add-needed ${SDL2}/lib/libSDL2-2.0.so.0 $out/bin/vermouth
  '';

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${umu-launcher}/bin"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  env.QT_QPA_PLATFORM = "offscreen";
  versionCheckKeepEnvironment = [ "QT_QPA_PLATFORM" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game and app launcher for Linux - native, Windows, and retro. KDE-first, lightweight, no frills";
    homepage = "https://github.com/dekomote/vermouth";
    changelog = "https://github.com/dekomote/vermouth/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "vermouth";
    platforms = lib.platforms.all;
  };
})
