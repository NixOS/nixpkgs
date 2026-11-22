{
  stdenv,
  buildPecl,
  lib,
  php,
  unixodbc,
  libiconv,
}:
buildPecl {
  pname = "sqlsrv";

  version = "5.13.3";
  sha256 = "sha256-HDCSynk7tnACygIsQSqsq7eaMpfucAXjt8yRsecWbSI=";

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    broken = lib.versionAtLeast php.version "8.6";
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
  };
}
