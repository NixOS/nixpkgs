{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libpng,
  qt6,
  versionCheckHook,
  zlib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zint";
  version = "2.15.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "zint";
    repo = "zint";
    tag = finalAttrs.version;
    hash = "sha256-+dXIU66HIS2mE0pa99UemMMFBGCYjupUX8P7q3G7Nis=";
  };

  patches = [
    # Fix cmake file installation
    # https://github.com/zint/zint/pull/8
    ./fix-installation-of-cmake-files.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
  ];

  propagatedBuildInputs = [
    libpng
    zlib
  ];

  cmakeFlags = [ (lib.cmakeBool "ZINT_QT6" true) ];

  doInstallCheck = true;
  nativeCheckInputs = [ versionCheckHook ];

  postInstall = ''
    install -Dm644 -t $out/share/applications $src/zint-qt.desktop
    install -Dm644 -t $out/share/pixmaps $src/zint-qt.png
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps $src/frontend_qt/images/scalable/zint-qt.svg
  '';

  meta = with lib; {
    description = "Barcode generating tool and library";
    longDescription = ''
      The Zint project aims to provide a complete cross-platform open source
      barcode generating solution. The package currently consists of a Qt based
      GUI, a CLI command line executable and a library with an API to allow
      developers access to the capabilities of Zint.
    '';
    homepage = "https://www.zint.org.uk";
    changelog = "https://github.com/zint/zint/blob/${finalAttrs.src.rev}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = [ lib.maintainers.azahi ];
    platforms = platforms.all;
    mainProgram = "zint";
  };
})
