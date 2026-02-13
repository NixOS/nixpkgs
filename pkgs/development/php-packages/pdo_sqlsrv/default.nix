{
  stdenv,
  buildPecl,
  lib,
  libiconv,
  unixODBC,
  php,
}:

buildPecl {
  pname = "pdo_sqlsrv";

  version = "5.10.1";
  sha256 = "sha256-x4VBlqI2vINQijRvjG7x35mbwh7rvYOL2wUTIV4GKK0=";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixODBC ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.5";
  };
}
