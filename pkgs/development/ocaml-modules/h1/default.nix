{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom,
  bigstringaf,
  faraday,
  httpun-types,
  alcotest,
  version ? "1.0.0",
}:

buildDunePackage {
  inherit version;

  pname = "h1";

  src = fetchurl {
    url = "https://github.com/robur-coop/ocaml-h1/releases/download/v${version}/h1-${version}.tbz";
    hash = "sha256-uFHRcNmfHiFmdMAMKiS5KilIwMylf/AoJCfxllrIvRM=";
  };

  propagatedBuildInputs = [
    angstrom
    bigstringaf
    faraday
    httpun-types
  ];

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = {
    description = "A high-performance, memory-efficient, and scalable web server for OCaml";
    homepage = "https://github.com/robur-coop/ocaml-h1";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.bsd3;
  };
}
