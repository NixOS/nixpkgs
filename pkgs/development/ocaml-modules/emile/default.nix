{ lib, buildDunePackage, fetchurl, ocaml
, angstrom, ipaddr, base64, pecu, uutf
, alcotest, cmdliner
}:

buildDunePackage rec {
  pname = "emile";
  version = "1.1";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/dinosaure/emile/releases/download/v${version}/emile-v${version}.tbz";
    sha256 = "0r1141makr0b900aby1gn0fccjv1qcqgyxib3bzq8fxmjqwjan8p";
  };

  buildInputs = [ cmdliner ];

  propagatedBuildInputs = [
    angstrom
    ipaddr
    base64
    pecu
    uutf
  ];

  # technically emile is available for ocaml >= 4.03, but alcotest
  # and angstrom (fmt) are only available for >= 4.08. Disabling
  # tests for < 4.08 at least improves the error message
  doCheck = lib.versionAtLeast ocaml.version "4.08";
  checkInputs = [ alcotest ];

  meta = with lib; {
    description = "Parser of email address according RFC822";
    license = licenses.mit;
    homepage = "https://github.com/dinosaure/emile";
    maintainers = [ maintainers.sternenseemann ];
  };
}
