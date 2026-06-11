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

  version = "5.13.1";
  sha256 = "sha256-NQpdZqE74R+t/26w1zkeWMG4ryzQq+FBJj9a8ZMP62k=";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
  };
}
