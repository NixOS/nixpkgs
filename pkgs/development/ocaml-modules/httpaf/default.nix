{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  angstrom,
  faraday,
  result,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "httpaf";
  version = "0.7.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = "httpaf";
    rev = finalAttrs.version;
    hash = "sha256-34hoeQ8i2L1id3/owvH3qlmTn+8avWoMN257PJxCZ34=";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [
    angstrom
    faraday
    result
  ];
  doCheck = true;

  meta = {
    description = "High-performance, memory-efficient, and scalable web server for OCaml";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (finalAttrs.src.meta) homepage;
  };
})
