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

  version = "5.13.0";
  sha256 = "sha256-76hZvMSNl/JSaNvevx2yXyVhDX+jaz7pEHPByZQR4kw=";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
    broken = lib.versionAtLeast php.version "8.5";
  };
}
