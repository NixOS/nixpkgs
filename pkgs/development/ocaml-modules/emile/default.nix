{
  lib,
  buildDunePackage,
  fetchurl,
  angstrom,
  ipaddr,
  base64,
  pecu,
  uutf,
  alcotest,
  cmdliner,
}:

buildDunePackage (finalAttrs: {
  pname = "emile";
  version = "1.1";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/dinosaure/emile/releases/download/v${finalAttrs.version}/emile-v${finalAttrs.version}.tbz";
    hash = "sha256:0r1141makr0b900aby1gn0fccjv1qcqgyxib3bzq8fxmjqwjan8p";
  };

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [
    angstrom
    ipaddr
    base64
    pecu
    uutf
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Parser of email address according RFC822";
    license = lib.licenses.mit;
    homepage = "https://github.com/dinosaure/emile";
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
