{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.1";
  sha256 = "sha256-YBYgz/07PlWWIAmcBWm4xCR/Ap7BitwCBr8m+ONXU9s=";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta.maintainers = lib.teams.php.members;
}
