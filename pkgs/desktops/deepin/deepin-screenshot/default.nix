{ stdenv, fetchFromGitHub, cmake, pkgconfig, qttools, qtx11extras,
  dtkcore, dtkwidget, dtkwm, deepin-turbo, dde-file-manager, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-screenshot";
  version = "4.1.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1sj6wv7n374i156qx7z03bhja9svzp4bzfgqwiclrqza0fnim9ba";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    qttools
    deepin.setupHook
  ];

  buildInputs = [
    dde-file-manager
    deepin-turbo
    dtkcore
    dtkwidget
    dtkwm
    qtx11extras
  ];

  postPatch = ''
    searchHardCodedPaths # debugging

    patchShebangs .

    fixPath ${deepin-turbo} /usr/bin/deepin-turbo-invoker src/dbusservice/com.deepin.Screenshot.service
    fixPath ${dde-file-manager} /usr/bin/dde-file-manager src/mainwindow.cpp
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Easy-to-use screenshot tool for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-screenshot;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo flokli ];
  };
}
