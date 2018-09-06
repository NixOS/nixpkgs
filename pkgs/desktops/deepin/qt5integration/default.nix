{ stdenv, fetchFromGitHub, pkgconfig, qmake, mtdev, gsettings-qt
, lxqt, qtx11extras, qtmultimedia, qtsvg, fontconfig, freetype
, qt5dxcb-plugin, qtstyleplugins, dtkcore, dtkwidget
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qt5integration";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0qf9ndsg8pz2n68y68a30d1hxr3ri8k4j00dxlbcf5cn5mbnny1b";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
  ];

  buildInputs = [
    dtkcore
    dtkwidget
    qt5dxcb-plugin
    mtdev
    lxqt.libqtxdg
    qtstyleplugins
    qtx11extras
    qtmultimedia
    qtsvg
  ];

  postPatch = ''
    sed -i dstyleplugin/dstyleplugin.pro \
           platformthemeplugin/qt5deepintheme-plugin.pro \
           iconengineplugins/svgiconengine/svgiconengine.pro \
           imageformatplugins/svg/svg.pro \
      -e "s,\$\$\[QT_INSTALL_PLUGINS\],$out/$qtPluginPrefix,"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugins for DDE";
    homepage = https://github.com/linuxdeepin/qt5integration;
    license = with licenses; [ gpl3 lgpl2Plus bsd2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
