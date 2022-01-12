{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.6";
  sha256 = "sha256-yjLjlezbREemnV6lGzX+sZw7xXWbRolv729+LKQajkM=";

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
