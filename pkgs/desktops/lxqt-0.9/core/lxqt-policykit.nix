{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, kwindowsystem
, lxqt-polkit_qt_1
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-policykit";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "2b0e784cf3a71bcee25cafc844ec34306eb17aaf";
    sha256 = "47ae74e6ab5816ec4ff9d30fa17d2c6394b7808d6617c6e2ccff23f58831204c";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    lxqt-polkit_qt_1
    libqtxdg liblxqt
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Policykit authentication agent";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
