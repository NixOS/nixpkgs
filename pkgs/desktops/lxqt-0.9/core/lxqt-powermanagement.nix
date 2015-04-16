{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, kwindowsystem
, libpthreadstubs, libXdmcp
, libqtxdg
, liblxqt
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-powermanagement";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "4bc9f66d12afb4bab72867c64769697aab74bfa4";
    sha256 = "7988d1260c1863b840a6f85974d716c23dca7ca8c839478e3abfd9e2a2d9042f";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    libpthreadstubs libXdmcp
    libqtxdg liblxqt
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Daemon use for power management and auto-suspend";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
