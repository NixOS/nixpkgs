{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom,
  base64,
  bigstringaf,
  fmt,
  ke,
  logs,
  pecu,
  prettym,
  unstrctrd,
  uutf,
}:

buildDunePackage (finalAttrs: {
  pname = "multipart_form";
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/multipart_form/releases/download/v${finalAttrs.version}/multipart_form-${finalAttrs.version}.tbz";
    hash = "sha256-lQdAZ5vmBOhkH1V3MuqYi+UGpyJPsSkoU6kEGYvchWA=";
  };

  propagatedBuildInputs = [
    angstrom
    base64
    bigstringaf
    fmt
    ke
    logs
    pecu
    prettym
    unstrctrd
    uutf
  ];

  meta = {
    description = "Implementation of RFC7578 in OCaml";
    homepage = "https://github.com/dinosaure/multipart_form";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
