{ lib, buildDunePackage, fetchurl, re, uutf }:

buildDunePackage rec {
  pname = "tyxml";
  version = "4.5.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocsigen/tyxml/releases/download/${version}/tyxml-${version}.tbz";
    sha256 = "0s30f72m457c3gbdmdwbx7ls9zg806nvm83aiz9qkpglbppwr6n6";
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
