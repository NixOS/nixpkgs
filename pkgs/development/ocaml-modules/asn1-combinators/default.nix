{ stdenv, fetchzip, ocaml, findlib, cstruct, zarith }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

let version = "0.1.1"; in

stdenv.mkDerivation {
  name = "ocaml-asn1-combinators-${version}";

  src = fetchzip {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/archive/${version}.tar.gz";
    sha256 = "1wl5g2cqd4dk33w0ski6z425cs4sgj980fw0xkwgz1w1xzywh4i2";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ cstruct zarith ];

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/mirleft/ocaml-asn1-combinators;
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    platforms = ocaml.meta.platforms;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
