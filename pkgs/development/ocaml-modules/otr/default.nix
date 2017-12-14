{ stdenv, buildOcaml, fetchFromGitHub, ocamlbuild, findlib, topkg, ocaml
, ppx_tools, ppx_sexp_conv, cstruct, ppx_cstruct, sexplib, result, nocrypto, astring
}:

buildOcaml rec {
  name = "otr";
  version = "0.3.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "hannesm";
    repo   = "ocaml-otr";
    rev    = "${version}";
    sha256 = "07zzix5mfsasqpqdx811m0x04gp8mq1ayf4b64998k98027v01rr";
  };

  buildInputs = [ ocamlbuild findlib topkg ppx_tools ppx_sexp_conv ppx_cstruct ];
  propagatedBuildInputs = [ cstruct sexplib result nocrypto astring ];

  buildPhase = "${topkg.run} build --tests true";

  inherit (topkg) installPhase;

  doCheck = true;
  checkPhase = "${topkg.run} test";

  meta = with stdenv.lib; {
    homepage = https://github.com/hannesm/ocaml-otr;
    description = "Off-the-record messaging protocol, purely in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
