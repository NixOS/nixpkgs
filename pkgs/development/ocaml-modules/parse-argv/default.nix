{ lib, fetchurl, buildDunePackage, ocaml
, astring
, ounit
}:

buildDunePackage rec {
  pname = "parse-argv";
  version = "0.2.0";

  useDune2 = true;

  minimumOCamlVersion = "4.03";

  src = fetchurl {
    url = "https://github.com/mirage/parse-argv/releases/download/v${version}/parse-argv-v${version}.tbz";
    sha256 = "06dl04fcmwpkydzni2fzwrhk0bqypd55mgxfax9v82x65xrgj5gw";
  };

  propagatedBuildInputs = [ astring ];

  doCheck = lib.versionAtLeast ocaml.version "4.04";
  nativeCheckInputs = [ ounit ];

  meta = {
    description = "Process strings into sets of command-line arguments";
    homepage = "https://github.com/mirage/parse-argv";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
