{ stdenv, buildPecl, lib, libiconv, unixODBC, php }:

buildPecl {
  pname = "pdo_sqlsrv";

  version = "5.9.0";
  sha256 = "0n4cnkldvyp1lrpj18ky2ii2dcaa51dsmh8cspixm7w76dxl3khg";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ unixODBC ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  meta.maintainers = lib.teams.php.members;
}
