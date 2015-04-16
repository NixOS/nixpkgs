{ stdenv, fetchgit
, cmake
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-globalkeys";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "4504880ff4c960a7cf1e971128c415390109feed";
    sha256 = "a8151a8c3ef37e0c9396b77a75eac29863de681df92c516319173eb5b8e7fd49";
  };

  buildInputs = [ stdenv cmake qt54.base qt54.tools qt54.x11extras kwindowsystem liblxqt libqtxdg ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Daemon and library for global keyboard shortcuts registration";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
