{ stdenv
, lib
, mkDerivation
, fetchurl
, cmake
, pkg-config
, polkit
, glib
, pcre
, libselinux
, libsepol
, util-linux
}:

mkDerivation rec {
  pname = "polkit-qt-1";
  version = "0.114.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-LrDyJEWIgpX/or+8DDaThHoPlzu2sMPkzOAhi+fjkH4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    glib
    pcre
    polkit
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libselinux libsepol util-linux ];

  meta = with lib; {
    description = "Qt wrapper around PolKit";
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.linux;
  };
}
