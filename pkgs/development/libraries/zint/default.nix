{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libpng,
  qtbase,
  qtsvg,
  qttools,
  versionCheckHook,
  wrapQtAppsHook,
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

  postPatch = ''
    # Fix cmake file installation
    # https://github.com/zint/zint/pull/8
    substituteInPlace CMakeLists.txt \
      --replace-fail 'DESTINATION "''${CMAKE_INSTALL_DATADIR}/zint"' 'DESTINATION lib/cmake/zint'
    substituteInPlace backend/CMakeLists.txt \
      --replace-fail 'DESTINATION "''${CMAKE_INSTALL_DATADIR}/zint"' 'DESTINATION lib/cmake/zint'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtsvg
    qttools
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
