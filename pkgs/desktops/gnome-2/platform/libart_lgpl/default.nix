{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libart_lgpl";
  version = "2.3.21";
  src = fetchurl {
    url = "mirror://gnome/sources/libart_lgpl/${lib.versions.majorMinor version}/libart_lgpl-${version}.tar.bz2";
    sha256 = "1yknfkyzgz9s616is0l9gp5aray0f2ry4dw533jgzj8gq5s1xhgx";
  };
  meta.mainProgram = "libart2-config";
}
