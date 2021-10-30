{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.3";
  sha256 = "1ffaqhckkk1qr5dk1fl7f8dm2w4lj4gqrgazzmc67acsdmp7z5f0";

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
