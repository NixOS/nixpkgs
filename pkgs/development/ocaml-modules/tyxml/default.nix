{ lib, buildDunePackage, fetchurl, re, uutf }:

buildDunePackage rec {
  pname = "tyxml";
  version = "4.4.0";

  src = fetchurl {
    url = "https://github.com/ocsigen/tyxml/releases/download/${version}/tyxml-${version}.tbz";
    sha256 = "0c150h2f4c4id73ickkdqkir3jya66m6c7f5jxlp4caw9bfr8qsi";
  };

  propagatedBuildInputs = [ uutf re ];

  meta = with lib; {
    homepage = "http://ocsigen.org/tyxml/";
    description = "A library that makes it almost impossible for your OCaml programs to generate wrong XML output, using static typing";
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      gal_bolle vbgl
      ];
  };

}
