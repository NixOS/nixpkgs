{ stdenv, fetchgit, cmake, qt54, pkgconfig, polkit, glib }:

stdenv.mkDerivation rec {
  basename = "polkit-qt-1";
  version = "0.112.0";
  name = "lxqt-${basename}-${version}";

  src = fetchgit {
    url = "git://anongit.kde.org/polkit-qt-1";
    rev = "40afa675bfa4cacd95487ce8b0544654c5f34e21";
    sha256 = "91c9ca0d67e0ab85da7274b30b201d4ccc6e5fb2b1ad904e93be4c7fe40d8472";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ polkit glib qt54.base ];

  # Need to override the installation directory
  patchPhase = ''
    PATTERN=\$\{POLKITQT-1_INSTALL_DIR}
    substituteInPlace PolkitQt-1Config.cmake.in --replace "$PATTERN" $out
  '';

  preConfigure = ''cmakeFlags="-DUSE_QT5=ON"'';

  meta = {
    description = "A Qt 5 wrapper around PolKit";
  };
}
