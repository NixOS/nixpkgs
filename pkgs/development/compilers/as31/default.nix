{ stdenv, fetchurl, yacc }:

let

  version = "2.3.1";

in stdenv.mkDerivation {
  name = "as31-${version}";
  src = fetchurl {
    name = "as31-${version}.tar.gz"; # Nix doesn't like the colons in the URL
    url = "http://wiki.erazor-zone.de/_media/wiki:projects:linux:as31:as31-${version}.tar.gz";
    sha256 = "0mbk6z7z03xb0r0ccyzlgkjdjmdzknck4yxxmgr9k7v8f5c348fd";
  };

  buildInputs = [ yacc ];

  preConfigure = ''
    chmod +x ./configure
  '';

  postConfigure = ''
    rm as31/parser.c
  '';

  meta = with stdenv.lib; {
    homepage = "http://wiki.erazor-zone.de/wiki:projects:linux:as31";
    description = "An 8031/8051 assembler by Ken Stauffer and Theo Deraadt which produces a variety of object code output formats";
    maintainers = with maintainers; [ aneeshusa ];
  };
}
