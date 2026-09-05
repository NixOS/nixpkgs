{
  lib,
  buildDunePackage,
  fetchurl,
  re,
  uutf,
}:

buildDunePackage rec {
  pname = "tyxml";
  version = "5.0.0";

  src = fetchurl {
    url = "https://github.com/ocsigen/tyxml/releases/download/${version}/tyxml-${version}.tbz";
    hash = "sha256-xyW7iRj/G2AeeSa3trR5n49Ktw9fup8JcNplfLgsB/I=";
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
