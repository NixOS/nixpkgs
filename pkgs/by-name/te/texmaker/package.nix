{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
  qt6Packages,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texmaker";
  version = "6.0.1";

  src = fetchurl {
    url = "http://www.xm1math.net/texmaker/texmaker-${finalAttrs.version}.tar.bz2";
    hash = "sha256-uMI13wzY/XcUzXDTte42MWOwJUqd6pGAeBuPDi5GyvY=";
  };

  patches = [
    # Check if the patch can be removed next release
    ./fix-build-with-qt-6-10.patch
  ];

  buildInputs = [
    qt6Packages.poppler
    qt6.qtbase
    qt6.qtwebengine
    qt6.qt5compat
    qt6.qttools
    zlib
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  qmakeFlags = [
    "DESKTOPDIR=${placeholder "out"}/share/applications"
    "ICONDIR=${placeholder "out"}/share/pixmaps"
    "METAINFODIR=${placeholder "out"}/share/metainfo"
  ];

  meta = {
    description = "TeX and LaTeX editor";
    longDescription = ''
      This editor is a full fledged IDE for TeX and
      LaTeX editing with completion, structure viewer, preview,
      spell checking and support of any compilation chain.
    '';
    homepage = "http://www.xm1math.net/texmaker/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      cfouche
      markuskowa
    ];
    mainProgram = "texmaker";
  };
})
