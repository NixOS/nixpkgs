{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, qtsvg,
  qtx11extras, dtkcore, dtkwidget, qt5integration, freeimage, libraw,
  libexif
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-image-viewer";
  version = "1.2.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1n1b3j65in6v7q5bxgkiam8qy56kjn9prld3sjrbc2mqzff8sm3q";
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
