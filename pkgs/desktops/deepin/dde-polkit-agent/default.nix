{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, polkit-qt,
  dtkcore, dtkwidget, dde-qt-dbus-factory, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-polkit-agent";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1x7mv63g8412w1bq7fijsdzi8832qjb6gnr1nykcv7imzlycq9m6";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "PolicyKit agent for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-polkit-agent;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
