{ lib, buildDunePackage, ocaml, fetchurl, alcotest }:

buildDunePackage rec {
  pname = "duration";
  version = "0.2.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/hannesm/duration/releases/download/${version}/duration-${version}.tbz";
    sha256 = "sha256-rRT7daWm9z//fvFyEXiSXuVVzw8jsj46sykYS8DBzmk=";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/hannesm/duration";
    description = "Conversions to various time units";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
