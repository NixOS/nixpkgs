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

    # Deprecate dcombobox.h header
    sed -i 's|dcombobox.h|QComboBox|' AuthDialog.h
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
