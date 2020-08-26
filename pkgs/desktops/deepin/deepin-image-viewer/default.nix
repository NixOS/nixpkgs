{ stdenv
, mkDerivation
, fetchFromGitHub
, pkgconfig
, qmake
, qttools
, qtsvg
, qtx11extras
, dtkcore
, dtkwidget
, qt5integration
, freeimage
, libraw
, libexif
, deepin
}:

mkDerivation rec {
  pname = "deepin-image-viewer";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "01524hfdy3wvdf07n9b3qb8jdpxzg2hwjpl4gxvr68qws5nbnb3c";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    qtsvg
    qtx11extras
    dtkcore
    dtkwidget
    qt5integration
    freeimage
    libraw
    libexif
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs viewer/generate_translations.sh
    fixPath $out /usr viewer/com.deepin.ImageViewer.service
    sed -i qimage-plugins/freeimage/freeimage.pro \
           qimage-plugins/libraw/libraw.pro \
      -e "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix,"
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
