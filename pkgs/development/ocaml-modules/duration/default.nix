{ lib, buildDunePackage, ocaml, fetchurl, alcotest }:

buildDunePackage rec {
  pname = "duration";
  version = "0.1.3";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/hannesm/duration/releases/download/${version}/duration-${version}.tbz";
    sha256 = "0m9r0ayhpl98g9vdxrbjdcllns274jilic5v8xj1x7dphw21p95h";
  };

  doCheck = lib.versionAtLeast ocaml.version "4.05";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://github.com/hannesm/duration";
    description = "Conversions to various time units";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
