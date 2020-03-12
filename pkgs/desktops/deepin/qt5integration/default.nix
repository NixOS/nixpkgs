{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, mtdev,
  lxqt, qtx11extras, qtmultimedia, qtsvg,
  qt5dxcb-plugin, qtstyleplugins, dtkcore, dtkwidget, deepin }:

mkDerivation rec {
  pname = "qt5integration";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "140wb3vcm2ji8jhqdxv8f4shiknia1zk8fssqlp09kzc1cmb4ncy";
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

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Qt platform theme integration plugins for DDE";
    homepage = https://github.com/linuxdeepin/qt5integration;
    license = with licenses; [ gpl3 lgpl2Plus bsd2 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
