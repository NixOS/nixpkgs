{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  alcotest,
}:

buildDunePackage rec {
  pname = "domain-name";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/hannesm/domain-name/releases/download/v${version}/domain-name-${version}.tbz";
    sha256 = "sha256-nseuLCJ3LBULhM+j8h2b8l+uFKeW8x4g31LYb0ZJnYk=";
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
