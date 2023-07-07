{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.12";
  sha256 = "072qd4i22g0qmz0h1p6jhxx8rv0c8k7pgzwk52qfdijc0pgzz75n";

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
