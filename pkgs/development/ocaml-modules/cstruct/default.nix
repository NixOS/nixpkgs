{
  lib,
  fetchurl,
  buildDunePackage,
  fmt,
  alcotest,
  crowbar,
}:

buildDunePackage (finalAttrs: {
  pname = "cstruct";
  version = "6.3.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cstruct/releases/download/v${finalAttrs.version}/cstruct-${finalAttrs.version}.tbz";
    hash = "sha256-lWsknd+1X9I1hMF2evKPZIcDPTZIiCF6FCddiY69d1Q=";
  };

  buildInputs = [ fmt ];

  doCheck = false; # Tests depend on cstruct-sexp
  checkInputs = [
    alcotest
    crowbar
  ];

  meta = {
    description = "Access C-like structures directly from OCaml";
    license = lib.licenses.isc;
    homepage = "https://github.com/mirage/ocaml-cstruct";
    maintainers = [ lib.maintainers.vbgl ];
  };
})
