{ stdenv, buildPecl, lib, unixODBC, libiconv }:

buildPecl {
  pname = "sqlsrv";

  version = "5.10.0";
  sha256 = "sha256-drPwg6Go8QNYHCG6OkbWyiV76uZyjNFYpkpGq1miJrQ=";

  buildInputs = [
    unixODBC
  ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    maintainers = teams.php.members;
  };
}
