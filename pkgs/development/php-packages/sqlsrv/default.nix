{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "sqlsrv";

  version = "5.8.1";
  sha256 = "0c9a6ghch2537vi0274vx0mn6nb1xg2qv7nprnf3xdfqi5ww1i9r";

  buildInputs = [
    pkgs.unixODBC
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libiconv
  ];

  meta.maintainers = lib.teams.php.members;
}
