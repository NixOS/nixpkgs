{ stdenv
, mkDerivation
, fetchFromGitHub
, pkg-config
, qmake
, dde-qt-dbus-factory
, dtkwidget
, gsettings-qt
, polkit-qt
, qtmultimedia
, qttools
, qtx11extras
, deepin
}:

mkDerivation rec {
  pname = "dde-polkit-agent";
  version = "5.2.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "076laqrnwr87dp459xl5ji51hisv1g3j4gsvx8bd31048rx3nfbn";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-qt-dbus-factory
    dtkwidget
    gsettings-qt
    polkit-qt
    qtmultimedia
    qtx11extras
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs translate_generation.sh

    # https://github.com/linuxdeepin/developer-center/issues/1721
    substituteInPlace policykitlistener.cpp --replace 'bool is_deepin = true' 'bool is_deepin = false'

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
