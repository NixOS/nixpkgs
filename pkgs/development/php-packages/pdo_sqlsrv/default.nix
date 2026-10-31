{
  stdenv,
  buildPecl,
  lib,
  libiconv,
  unixodbc,
  php,
}:
buildPecl {
  pname = "pdo_sqlsrv";

  version = "5.13.3";
  sha256 = "sha256-GYp7N9oGWNNqk9FYoOwXmxN7Ok0kHJCmZQrp7o+R7Eo=";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.6";
  };
}
