{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.0.1";
  sha256 = "1w8jmf1qpggdvq0ndfi86n7i7cqgh1s8q6hys2lijvi37rzn0nar";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta.maintainers = lib.teams.php.members;
}
