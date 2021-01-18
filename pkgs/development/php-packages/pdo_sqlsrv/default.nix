{ buildPecl, lib, pkgs, php }:

buildPecl {
  pname = "pdo_sqlsrv";

  version = "5.8.1";
  sha256 = "06ba4x34fgs092qq9w62y2afsm1nyasqiprirk4951ax9v5vcir0";

  internalDeps = [ php.extensions.pdo ];

  buildInputs = [ pkgs.unixODBC ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.libiconv ];

  meta.maintainers = lib.teams.php.members;
}
