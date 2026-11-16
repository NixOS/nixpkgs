{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  hevea,
  zarith,
  dune-configurator,
  stdlib-shims,
  ppx_deriving_yojson,
  yojson,
  findlib,
  cppo,
  gcc,
  perl,
}:

buildDunePackage (finalAttrs: {
  pname = "goblint-cil";
  version = "2.2.0";

  minimalOCamlVersion = "4.12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "goblint";
    repo = "cil";
    tag = finalAttrs.version;
    hash = "sha256-HS9IDBqLoRmnvpQdlR0paTi6Z2JkoeTbo6XSiAe2peY=";
  };

  nativeBuildInputs = [
    hevea
    cppo
    gcc
  ];

  propagatedBuildInputs = [
    zarith
    dune-configurator
    stdlib-shims
    ppx_deriving_yojson
    yojson
    findlib
    perl
  ];

  # Currently broken, doesn't properly pass all tests, fails with many compile errors
  doCheck = false;

  meta = {
    description = "Front-end for the C programming language that facilitates program analysis and transformation";
    homepage = "https://goblint.github.io/cil/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
