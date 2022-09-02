{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.7";
  sha256 = "sha256-0NwNC1aphfT1LOogcXEz09oFNoh2vA+UMXweYOAxnn0=";

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
