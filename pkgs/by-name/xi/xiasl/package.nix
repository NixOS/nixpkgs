{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, libsForQt5
, acpica-tools
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xiasl";
  version = "1.1.67";

  src = fetchFromGitHub {
    owner = "ic005k";
    repo = "Xiasl";
    rev = finalAttrs.version;
    hash = "sha256-6RJeNLgeFchCjYLcwKgGtV0dLyHO7gYpIpo/3BBh/wM=";
  };

  buildInputs = [
    libsForQt5.qtbase
  ];

  nativeBuildInputs = [
    copyDesktopItems
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
  ];

  postPatch = ''
    rm libqscintilla2_qt5.so
    ln -s '${lib.getLib libsForQt5.qscintilla}/lib/libqscintilla2_qt5.so' .

    substituteInPlace Xiasl.pro \
      --replace-warn '/opt/$''${TARGET}' "$out"

    substituteInPlace *.cpp \
      --replace-quiet 'appInfo.filePath() + "/iasl"' '"${acpica-tools}/bin/iasl"' \
      --replace-quiet 'appInfo.filePath() + "/acpidump"' '"${acpica-tools}/bin/acpidump"' \
  '';

  postInstall = ''
    install -Dm644 icon.png "$out/share/pixmaps/xiasl.png"
  '';

  preFixup = ''
    patchelf --add-rpath '${lib.makeLibraryPath [ libsForQt5.qscintilla ]}' "$out/bin/Xiasl"
  '';

  dontStrip = true; # https://github.com/NixOS/patchelf/issues/99#issuecomment-355536880

  desktopItems = [
    (makeDesktopItem {
      name = "xiasl";
      exec = "Xiasl";
      icon = "xiasl";
      desktopName = "Xiasl";
      comment = "Cross-platform DSDT & SSDT IDE";
      categories = [ "Development" "IDE" ];
    })
  ];

  meta = {
    description = "A cross-platform DSDT & SSDT IDE";
    homepage = "https://github.com/ic005k/Xiasl";
    downloadPage = "${finalAttrs.meta.homepage}/releases";
    changelog = "${finalAttrs.meta.downloadPage}/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hacker1024 ];
    mainProgram = "Xiasl";
    platforms = with lib.platforms; linux ++ darwin;
    broken = stdenv.hostPlatform.isDarwin; # Additional patching is required for Darwin.
  };
})
