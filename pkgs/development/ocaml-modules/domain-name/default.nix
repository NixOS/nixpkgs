{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  alcotest,
}:

buildDunePackage rec {
  pname = "domain-name";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/hannesm/domain-name/releases/download/v${version}/domain-name-${version}.tbz";
    sha256 = "sha256-Hboy81p81cyBh9IeLMIaC2Z6ZFRHoO7+V6/jyiW8RWY=";
  };

  minimalOCamlVersion = "4.04";
  duneVersion = "3";

  checkInputs = [ alcotest ];

  doCheck = lib.versionAtLeast ocaml.version "4.08";

  meta = {
    homepage = "https://github.com/hannesm/domain-name";
    description = "RFC 1035 Internet domain names";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
