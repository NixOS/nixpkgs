{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.1.6";
  sha256 = "1spx6581ly2r8pn9b632bi8429sy762v04ramrlnf7469pf8ggxr";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta.maintainers = lib.teams.php.members;
}
