{ stdenv, fetchgit, pkgconfig
, cmake
, qt48

, libpthreadstubs, libXdmcp

, libqtxdg
, liblxqt
}:

stdenv.mkDerivation rec {
  basename = "lxqt-powermanagement";
  version = "0.7.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "3eda208f9c5c1802fb5e184a5221edeb73f5e7c5";
    sha256 = "c326f8059de6178fdb8d641d1db7f6eee53bd4e8e1d9610ea1e635b6cf9dce62";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake qt48
    libpthreadstubs libXdmcp
    libqtxdg liblxqt
  ];

  patchPhase = ''
    substituteInPlace src/lid.cpp --replace qt4/QtCore/qobject.h QObject
    substituteInPlace src/lidwatcher.cpp --replace qt4/QtCore/qprocess.h QProcess
    substituteInPlace src/lidwatcher.cpp --replace qt4/QtCore/qtextstream.h QTextStream
  '';

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Daemon use for power management and auto-suspend";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
