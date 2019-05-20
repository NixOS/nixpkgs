{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, polkit-qt,
  dtkcore, dtkwidget, dde-qt-dbus-factory, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-polkit-agent";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1ih78sxhnn6hbx9mzhalx95dk18f217mjbvymf8dky2vkmw8vnmx";
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

  patches = [
    ./dde-polkit-agent.plugins-dir.patch
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
