{
  lib,
  buildDunePackage,
  fetchurl,
  ocaml,
  angstrom,
  ipaddr,
  base64,
  pecu,
  uutf,
  alcotest,
  cmdliner,
}:

buildDunePackage rec {
  pname = "emile";
  version = "1.1";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/dinosaure/emile/releases/download/v${version}/emile-v${version}.tbz";
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

  meta = with lib; {
    description = "Parser of email address according RFC822";
    license = licenses.mit;
    homepage = "https://github.com/dinosaure/emile";
    maintainers = [ maintainers.sternenseemann ];
  };
}
