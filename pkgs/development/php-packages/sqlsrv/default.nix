{
  stdenv,
  buildPecl,
  lib,
  unixodbc,
  libiconv,
}:

buildPecl {
  pname = "sqlsrv";

  version = "5.13.1";
  sha256 = "sha256-fE6o8l67yJmQhCOefg73UxUJfgE98OKQ/O92w9l3udg=";

  buildInputs = [ unixodbc ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = lib.licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    teams = [ lib.teams.php ];
  };
}
