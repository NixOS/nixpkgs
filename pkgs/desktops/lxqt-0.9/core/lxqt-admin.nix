# TODO: required liboobs-1, which isn't available
{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-admin";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "e1d866a6ac5e61718ca96add6496842bc6ffc619";
    sha256 = "d76a17381bc22bc9db4b678dee76ac752e228b00893b3353b309ed1b8da68d27";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    liblxqt libqtxdg
  ];

  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "About dialog for lxde-qt";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
