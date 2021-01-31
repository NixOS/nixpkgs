{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "sqlsrv";

  version = "5.9.0";
  sha256 = "1css440b4qrbblmcswd5wdr2v1rjxlj2iicbmvjq9fg81028w40a";

  buildInputs = [
    pkgs.unixODBC
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.libiconv
  ];

  meta.maintainers = lib.teams.php.members;
}
