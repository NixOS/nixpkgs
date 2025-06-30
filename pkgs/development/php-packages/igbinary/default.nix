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

  meta = {
    description = "Binary serialization for PHP";
    homepage = "https://github.com/igbinary/igbinary/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.php ];
  };
}
