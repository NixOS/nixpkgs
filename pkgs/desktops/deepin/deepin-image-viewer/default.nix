{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, qtsvg,
  qtx11extras, dtkcore, dtkwidget, qt5integration, freeimage, libraw,
  libexif, deepin
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-image-viewer";
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0r92sr68vlhw4sdz0c94k6ckxz7nhqbangxr66y3vvy9rcpkm6xc";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Image Viewer for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-image-viewer;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ]; # See https://github.com/NixOS/nixpkgs/pull/46463#issuecomment-420274189
    maintainers = with maintainers; [ romildo ];
  };
}
