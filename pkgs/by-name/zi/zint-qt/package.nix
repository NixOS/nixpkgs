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
  withGUI ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zint${lib.optionalString withGUI "-qt"}";
  version = "2.16.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "zint";
    repo = "zint";
    tag = finalAttrs.version;
    hash = "sha256-5zVGtnm6QdehDL+R7ZNq7AdgUIOIySPWGlS6GbJK+/4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals withGUI [
    qt6.wrapQtAppsHook
  ];

  buildInputs = lib.optionals withGUI [
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
  ];

  propagatedBuildInputs = [
    libpng
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "ZINT_USE_QT" withGUI)
  ]
  ++ lib.optionals withGUI [
    (lib.cmakeBool "ZINT_QT6" true) # do not use Qt 5
  ];

  doInstallCheck = true;
  nativeCheckInputs = [ versionCheckHook ];

  postInstall = lib.optionalString withGUI ''
    install -Dm644 -t $out/share/applications $src/zint-qt.desktop
    install -Dm644 -t $out/share/pixmaps $src/zint-qt.png
    install -Dm644 -t $out/share/icons/hicolor/scalable/apps $src/frontend_qt/images/scalable/zint-qt.svg
  '';

  meta = {
    description = "Barcode generating tool and library";
    longDescription = ''
      The Zint project aims to provide a complete cross-platform open source
      barcode generating solution. The package currently consists of "${lib.optionalString withGUI "a Qt based GUI, "}
      a CLI command line executable and a library with an API to allow
      developers access to the capabilities of Zint.
    '';
    homepage = "https://www.zint.org.uk";
    changelog = "https://github.com/zint/zint/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.azahi ];
    platforms = lib.platforms.all;
    mainProgram = "zint${lib.optionalString withGUI "-qt"}";
  };
})
