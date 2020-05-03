{ stdenv
, mkDerivation
, fetchFromGitHub
, pkgconfig
, qmake
, qttools
, polkit-qt
, dtkcore
, dtkwidget
, dde-qt-dbus-factory
, deepin
}:

mkDerivation rec {
  pname = "dde-polkit-agent";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "00p8syx6rfwhq7wdsk37hm9mvwd0kwj9h0s39hii892h1psd84q9";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    dtkcore
    dtkwidget
    polkit-qt
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs translate_generation.sh

    fixPath $out /usr dde-polkit-agent.pro polkit-dde-authentication-agent-1.desktop
    fixPath /run/current-system/sw /usr/lib/polkit-1-dde/plugins pluginmanager.cpp
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "PolicyKit agent for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-polkit-agent";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
