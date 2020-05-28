{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dtkcore
, dtkgui
, dtkwidget
, freeimage
, gio-qt
, libexif
, libraw
, qtmultimedia
, qtsvg
, qttools
, qtx11extras
, udisks2-qt5
, deepin
}:

mkDerivation rec {
  pname = "deepin-image-viewer";
  version = "5.6.3.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "02b5dkm9hcjhafvp0s7ssr7zal63xy8z0b8ax466b3dpsmrps851";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dtkcore
    dtkgui
    dtkwidget
    freeimage
    gio-qt
    libexif
    libraw
    qtmultimedia
    qtsvg
    qtx11extras
    udisks2-qt5
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    patchShebangs viewer/generate_translations.sh

    fixPath $out /usr viewer/com.deepin.ImageViewer.service

    sed -i qimage-plugins/freeimage/freeimage.pro \
           qimage-plugins/libraw/libraw.pro \
      -e "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix,"
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Image Viewer for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-image-viewer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ]; # See https://github.com/NixOS/nixpkgs/pull/46463#issuecomment-420274189
    maintainers = with maintainers; [ romildo ];
  };
}
