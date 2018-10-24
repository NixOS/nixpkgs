{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, polkit-qt,
dtkcore, dtkwidget, dde-qt-dbus-factory }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-polkit-agent";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1n3hys5hhhd99ycpx4im6ihy53vl9c28z7ls7smn117h3ca4c8wc";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
  ];

  buildInputs = [
    dde-qt-dbus-factory
    dtkcore
    dtkwidget
    polkit-qt
  ];

  postPatch = ''
    patchShebangs .

    sed -i dde-polkit-agent.pro polkit-dde-authentication-agent-1.desktop \
      -e "s,/usr,$out,"

    sed -i pluginmanager.cpp \
      -e "s,/usr/lib/polkit-1-dde/plugins,/run/current-system/sw/lib/polkit-1-dde/plugins,"
  '';

  meta = with stdenv.lib; {
    description = "PolicyKit agent for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-polkit-agent;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
