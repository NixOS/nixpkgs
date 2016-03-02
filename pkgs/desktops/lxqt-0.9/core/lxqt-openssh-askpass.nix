{ stdenv, fetchgit, pkgconfig
, cmake
, qt54
, kwindowsystem
, liblxqt
, libqtxdg
, standardPatch
}:

stdenv.mkDerivation rec {
  basename = "lxqt-openssh-askpass";
  version = "0.9.0";
  name = "${basename}-${version}";

  src = fetchgit {
    url = "https://github.com/lxde/${basename}.git";
    rev = "d49d5ac0fd52abbdbfecc7c92a8bec4ba4ff47e9";
    sha256 = "40553281b469196efd961df4b34e0b37df1775526f1d9c473d38688be3d9586c";
  };

  buildInputs = [
    stdenv pkgconfig
    cmake
    qt54.base qt54.tools qt54.x11extras
    kwindowsystem
    liblxqt libqtxdg
  ];

  # Need to override the LXQT_TRANSLATIONS_DIR variable from liblxqt
  patchPhase = standardPatch;

  meta = {
    homepage = "http://www.lxqt.org";
    description = "Tool used with openssh to prompt the user for password";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ellis ];
  };
}
