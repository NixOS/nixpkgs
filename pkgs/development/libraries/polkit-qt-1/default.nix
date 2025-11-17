{
  lib,
  mkDerivation,
  fetchurl,
  cmake,
  pkg-config,
  polkit,
  glib,
}:

mkDerivation rec {
  pname = "polkit-qt-1";
  version = "0.114.0";

  src = fetchurl {
    url = "mirror://kde/stable/polkit-qt-1/polkit-qt-1-${version}.tar.xz";
    sha256 = "sha256-LrDyJEWIgpX/or+8DDaThHoPlzu2sMPkzOAhi+fjkH4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    polkit
  ];

  meta = {
    description = "Qt wrapper around PolKit";
    maintainers = with lib.maintainers; [ ttuegel ];
    platforms = lib.platforms.linux;
  };
}
