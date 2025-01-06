{
  lib,
  buildDunePackage,
  fetchurl,
  re,
  uutf,
}:

buildDunePackage rec {
  pname = "tyxml";
  version = "4.6.0";

  src = fetchurl {
    url = "https://github.com/ocsigen/tyxml/releases/download/${version}/tyxml-${version}.tbz";
    hash = "sha256-v+tnPGtOEgpOykxIRIrdR9w/jQLCtA9j/9zMTpHJAt0=";
  };

  propagatedBuildInputs = [
    uutf
    re
  ];

  meta = {
    homepage = "http://ocsigen.org/tyxml/";
    description = "Library that makes it almost impossible for your OCaml programs to generate wrong XML output, using static typing";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      gal_bolle
      vbgl
    ];
  };

}
