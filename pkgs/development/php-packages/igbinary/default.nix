{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";

  version = "3.2.1";
  sha256 = "sha256-YBYgz/07PlWWIAmcBWm4xCR/Ap7BitwCBr8m+ONXU9s=";

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
