{
  lib,
  buildDunePackage,
  fetchurl,
  fmt,
  bigstringaf,
  angstrom,
  alcotest,
}:

buildDunePackage rec {
  pname = "encore";
  version = "0.8.1";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/mirage/encore/releases/download/v${version}/encore-${version}.tbz";
    hash = "sha256-qg6heSBc6OSfb7vZxEi4rrKh+nx+ffnsCfVvhVR3yY0=";
  };

  duneVersion = "3";

  propagatedBuildInputs = [
    angstrom
    fmt
    bigstringaf
  ];
  checkInputs = [ alcotest ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/mirage/encore";
    description = "Library to generate encoder/decoder which ensure isomorphism";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
