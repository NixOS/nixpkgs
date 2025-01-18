{ buildPecl, lib }:

buildPecl {
  pname = "igbinary";
  version = "3.2.14";
  sha256 = "sha256-YzcUek+4iAclZmdIN72pko7gbufwEUtDOLhsgWIykl0=";

  configureFlags = [ "--enable-igbinary" ];
  makeFlags = [ "phpincludedir=$(dev)/include" ];
  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Binary serialization for PHP";
    homepage = "https://github.com/igbinary/igbinary/";
    license = licenses.bsd3;
    maintainers = teams.php.members;
  };
}
