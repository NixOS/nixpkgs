{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

buildPecl rec {
  pname = "pinba";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "tony2001";
    repo = "pinba_extension";
    rev = "RELEASE_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-XiK7U770RIn7QX+336z3da+WYGgLnqG4ijyUpQ3GDHM=";
  };

  # Fix GCC 14 build.
  # from incompatible pointer type [-Wincompatible-pointer-types
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    description = "PHP extension for Pinba";
    longDescription = ''
      Pinba is a MySQL storage engine that acts as a realtime monitoring and
      statistics server for PHP using MySQL as a read-only interface.
    '';
    license = lib.licenses.lgpl2Plus;
    homepage = "http://pinba.org/";
    teams = [ lib.teams.php ];
  };
}
