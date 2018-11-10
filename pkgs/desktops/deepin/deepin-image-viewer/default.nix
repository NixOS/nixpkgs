{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, qtsvg,
  qtx11extras, dtkcore, dtkwidget, qt5integration, freeimage, libraw,
  libexif
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-image-viewer";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "10x1dc770hg7zn3ra6558mqq8lz4g7x19j3k4c39l6wrr690w58s";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
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
    patchShebangs .
    sed -i qimage-plugins/freeimage/freeimage.pro \
           qimage-plugins/libraw/libraw.pro \
      -e "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix,"
    sed -i viewer/com.deepin.ImageViewer.service \
      -e "s,/usr,$out,"
  '';

  meta = with stdenv.lib; {
    description = "Image Viewer for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-image-viewer;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
