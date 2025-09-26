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

buildDunePackage rec {
  pname = "multipart_form";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/dinosaure/multipart_form/releases/download/v${version}/multipart_form-${version}.tbz";
    hash = "sha256-IqGGnDJtE0OKrtt+ah1Cy9zx4wavEl9eXXjZSh/M2JE=";
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
}
