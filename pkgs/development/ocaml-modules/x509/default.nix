{ stdenv, buildOcaml, fetchFromGitHub, ocaml, findlib, asn1-combinators, nocrypto
, ounit, ocaml_oasis, ppx_sexp_conv, cstruct-unix
}:

buildOcaml rec {
  name = "x509";
  version = "0.5.3";

  mininimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-x509";
    rev    = "${version}";
    sha256 = "07cc3z6h87460z3f4vz8nlczw5jkc4vjhix413z9x6nral876rn7";
  };

  buildInputs = [ ocaml ocaml_oasis findlib ounit ppx_sexp_conv cstruct-unix ];
  propagatedBuildInputs = [ asn1-combinators nocrypto ];

  configureFlags = "--enable-tests";
  configurePhase = "./configure --prefix $out $configureFlags";

  doCheck = true;
  checkTarget = "test";
  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirleft/ocaml-x509;
    description = "X509 (RFC5280) handling in OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vbgl ];
  };
}
