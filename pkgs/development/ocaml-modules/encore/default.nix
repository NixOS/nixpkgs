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
    longDescription = ''
      Encore is a little library to provide an interface to generate an angstrom decoder and
      an internal encoder from a shared description. The goal is to ensure a dual isomorphism
      between them.
    '';
    changelog = "https://raw.githubusercontent.com/mirage/encore/refs/tags/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
