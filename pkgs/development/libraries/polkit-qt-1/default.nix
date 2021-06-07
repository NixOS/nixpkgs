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
  version = "0.113.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-W4ZqKVTvEP+2YVbi/orQMhtVKKjfLkqRsC9QQc5VY6c=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    glib
    pcre
    polkit
  ] ++ lib.optionals stdenv.isLinux [ libselinux libsepol util-linux ];

  meta = with lib; {
    description = "A Qt wrapper around PolKit";
    maintainers = with maintainers; [ ttuegel ];
    platforms = platforms.linux;
  };
}
