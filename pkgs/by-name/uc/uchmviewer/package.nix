{
  lib,
  stdenv,
  fetchFromGitHub,
  chmlib,
  libzip,
  qt6,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uchmviewer";
  version = "8.4";

  src = fetchFromGitHub {
    owner = "eBookProjects";
    repo = "uChmViewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p3KIIg2B+sSlwJr1rNMP7JByxYXyYFsj+UyUiDbJge8=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    chmlib
    libzip
    qt6.qt5compat
    qt6.qtwebengine
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_WEBENGINE" true)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/uchmviewer.app $out/Applications
    ln -s $out/Applications/uchmviewer.app/Contents/MacOS/uchmviewer $out/bin/uchmviewer
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/eBookProjects/uChmViewer/releases/tag/v${finalAttrs.version}";
    description = "CHM (Winhelp) files viewer (fork of KchmViewer)";
    homepage = "https://github.com/eBookProjects/uChmViewer";
    license = lib.licenses.gpl3Plus;
    mainProgram = "uchmviewer";
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.unix;
  };
})
