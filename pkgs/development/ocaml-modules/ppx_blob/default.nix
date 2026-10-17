{
  lib,
  fetchurl,
  buildDunePackage,
  ocaml,
  alcotest,
  ppxlib,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_blob";
  version = "0.9.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/johnwhitington/ppx_blob/releases/download/${finalAttrs.version}/ppx_blob-${finalAttrs.version}.tbz";
    sha256 = "sha256-8RXpCl8Qdc7cnZMKuRJx+GcOzk3uENwRR6s5uK+1cOQ=";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [ ppxlib ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/johnwhitington/ppx_blob";
    description = "OCaml ppx to include binary data from a file as a string";
    license = lib.licenses.unlicense;
  };
})
