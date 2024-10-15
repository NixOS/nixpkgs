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

  meta = with lib; {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    maintainers = teams.php.members;
  };
}
