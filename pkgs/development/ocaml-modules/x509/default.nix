{ stdenv, fetchzip, ocaml, findlib, asn1-combinators, nocrypto, ounit }:

let version = "0.4.0"; in

stdenv.mkDerivation {
  name = "ocaml-x509-${version}";

  src = fetchzip {
    url = "https://github.com/mirleft/ocaml-x509/archive/${version}.tar.gz";
    sha256 = "0z4c19y625ipx2anpq25pzly1fdi3cklhk130kriybrczvmd2b29";
  };

  buildInputs = [ ocaml findlib ounit ];
  propagatedBuildInputs = [ asn1-combinators nocrypto ];

  configureFlags = "--enable-tests";
  doCheck = true;
  checkTarget = "test";
  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirleft/ocaml-x509;
    description = "X509 (RFC5280) handling in OCaml";
    platforms = ocaml.meta.platforms;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
