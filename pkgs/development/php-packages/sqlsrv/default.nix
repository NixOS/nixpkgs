{ stdenv, buildPecl, lib, unixODBC, libiconv }:

buildPecl {
  pname = "sqlsrv";

  version = "5.9.0";
  sha256 = "1css440b4qrbblmcswd5wdr2v1rjxlj2iicbmvjq9fg81028w40a";

  buildInputs = [
    unixODBC
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  meta.maintainers = lib.teams.php.members;
}
