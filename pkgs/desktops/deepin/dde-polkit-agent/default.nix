{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, qttools, polkit-qt,
  dtkcore, dtkwidget, dde-qt-dbus-factory, deepin }:

mkDerivation rec {
  pname = "dde-polkit-agent";
  version = "0.2.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0syg121slpd6d9xpifgcf85lg9ca0k96cl1g3rjvsmczs2d2ffgf";
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

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "PolicyKit agent for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-polkit-agent;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
