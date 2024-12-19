{
  lib,
  buildDunePackage,
  ocaml,
  fetchurl,
  alcotest,
}:

buildDunePackage rec {
  pname = "domain-name";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/hannesm/domain-name/releases/download/v${version}/domain-name-${version}.tbz";
    sha256 = "sha256-pcBuIoRYlSAZc+gS/jAZJ00duBwKeHPabIAHxK0hCMU=";
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
