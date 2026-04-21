{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  copyDesktopItems,
  makeDesktopItem,
}:

# we now have libqmatrixclient so a future version of tensor that supports it
# should use that

stdenv.mkDerivation (finalAttrs: {
  pname = "tensor";
  version = "unstable-2017-02-21";

  src = fetchFromGitHub {
    owner = "davidar";
    repo = "tensor";
    rev = "f3f3056d770d7fb4a21c610cee7936ee900569f5";
    hash = "sha256-aR6TsfUxsxoSDaIWYgRCwd7BCgekSEqY6LpDoQ5DNqY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    copyDesktopItems
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtquickcontrols
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "tensor";
      exec = "tensor";
      icon = "tensor.png";
      comment = finalAttrs.meta.description;
      desktopName = "Tensor Matrix Client";
      genericName = finalAttrs.meta.description;
      categories = [
        "Chat"
        "Utility"
      ];
      mimeTypes = [ "application/x-chat" ];
    })
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        cp -r tensor.app $out/Applications/tensor.app

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -Dm755 tensor $out/bin/tensor
        install -Dm644 client/logo.png \
                       $out/share/icons/hicolor/512x512/apps/tensor.png

        runHook postInstall
      '';

  meta = {
    homepage = "https://github.com/davidar/tensor";
    description = "Cross-platform Qt5/QML-based Matrix client";
    mainProgram = "tensor";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = libsForQt5.qtbase.meta.platforms;
  };
})
