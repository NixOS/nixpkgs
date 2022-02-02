{ stdenv, buildPecl, lib, libiconv, unixODBC, php }:

buildPecl {
  pname = "pdo_sqlsrv";

  version = "5.10.0";
  sha256 = "sha256-BEa7i/8egvz9mT69dl0dxWcVo+dURT9Dzo6f6EdlESo=";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixODBC ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  meta = with lib; {
    description = "Microsoft Drivers for PHP for SQL Server";
    license = licenses.mit;
    homepage = "https://github.com/Microsoft/msphpsql";
    maintainers = teams.php.members;
  };
}
