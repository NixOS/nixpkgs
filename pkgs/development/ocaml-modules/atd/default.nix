{ stdenv, fetchurl, which, ocaml, findlib, menhir, easy-format }:

stdenv.mkDerivation rec {
  name = "atd-1.1.2";
  
  src = fetchurl {
    url = "http://mjambon.com/releases/atd/${name}.tar.gz";
    sha256 = "14bjlflx8fm5xm4rj393xyqyy9yaz72qjki7lklpbv9a35ihrw8f";
  };

  buildInputs = [ which ocaml findlib menhir easy-format ];

  createFindlibDestdir = true;

  preBuild = "makeFlagsArray=(PREFIX=$out)";
  preInstall = "mkdir -p $out/bin";

  meta = with stdenv.lib;
    { description = "Parser for the ATD data format description language";
      maintainers = with maintainers; [ emery ];
    };
}
