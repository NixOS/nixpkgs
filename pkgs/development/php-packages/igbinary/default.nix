{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.2";
  sha256 = "0321pb0298fa67qwj5nhhabkjiaxna5mag15ljyrqzpivimvny92";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta.maintainers = lib.teams.php.members;
}
