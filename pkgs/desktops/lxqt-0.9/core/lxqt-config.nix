{ stdenv, fetchgit, pkgconfig
, cmake
, libpthreadstubs
, libXdmcp
, libxcb
, libXcursor
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-config";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "f4c15db2d9e9fb130d58ed691a4a6be886d933ef";
    sha256 = "80b3c357f6ca1328ce5dc6c63039869e38680b96758daa5d1f2f5e0d73f441ad";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    libpthreadstubs libXdmcp libxcb libXcursor
    liblxqt libqtxdg libxcb
  ];

  # Need to override /etc/xdg
  patchPhase = ''
    substituteInPlace src/CMakeLists.txt --replace /etc/xdg etc/xdg
  '' + standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "System configuration (control center)";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
