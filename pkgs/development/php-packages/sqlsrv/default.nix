{
  stdenv,
  buildPecl,
  lib,
  unixodbc,
  libiconv,
}:
buildPecl {
  pname = "sqlsrv";

  version = "5.13.0";
  sha256 = "sha256-MdbCg1oFp7btDw3bZ1VsqRRlKlelccJokfAtitmbflw=";

  buildInputs = [unixodbc] ++ lib.optionals stdenv.hostPlatform.isDarwin [libiconv];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [lib.teams.php];
  };
}
