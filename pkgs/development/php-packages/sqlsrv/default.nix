{
  stdenv,
  buildPecl,
  lib,
  unixODBC,
  libiconv,
}:

buildPecl {
  pname = "sqlsrv";

  version = "5.10.1";
  sha256 = "sha256-XNrttNiihjQ+azuZmS2fy0So+2ndAqpde8IOsupeWdI=";

  buildInputs = [ unixODBC ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    maintainers = lib.teams.php.members;
  };
}
