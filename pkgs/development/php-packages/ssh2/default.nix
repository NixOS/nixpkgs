{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "ssh2";

  version = "1.2";
  sha256 = "0afrxi69jzapvhafrwk2c0bn0672065bdzqhn3vr4mjmbdgj17vz";

  buildInputs = [ pkgs.libssh2 ];
  configureFlags = [ "--with-ssh2=${pkgs.libssh2.dev}" ];

  meta.maintainers = lib.teams.php.members;
}
