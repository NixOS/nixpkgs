{ lib, buildDunePackage, fetchurl, re, uutf }:

buildDunePackage rec {
  pname = "tyxml";
  version = "4.3.0";

  src = fetchurl {
    url = "https://github.com/ocsigen/tyxml/releases/download/${version}/tyxml-${version}.tbz";
    sha256 = "1hxzppfvsdls2y8qiwvz31hmffzh2hgglf01am1vzf2f31mxf6vf";
  };

  propagatedBuildInputs = [ uutf re ];

  meta = with lib; {
    homepage = http://ocsigen.org/tyxml/;
    description = "A library that makes it almost impossible for your OCaml programs to generate wrong XML output, using static typing";
    license = licenses.lgpl21;
    maintainers = with maintainers; [
      gal_bolle vbgl
      ];
  };

}
