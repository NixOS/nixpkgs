{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.2";
  sha256 = "0321pb0298fa67qwj5nhhabkjiaxna5mag15ljyrqzpivimvny92";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Binary serialization for PHP";
    license = licenses.bsd3;
    homepage = "https://github.com/igbinary/igbinary/";
    maintainers = teams.php.members;
  };
}
