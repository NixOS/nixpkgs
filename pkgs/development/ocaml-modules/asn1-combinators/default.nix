{ stdenv, fetchzip, ocaml, findlib, cstruct, zarith, ounit }:

assert stdenv.lib.versionAtLeast (stdenv.lib.getVersion ocaml) "4.01";

let version = "0.1.2"; in

stdenv.mkDerivation {
  name = "ocaml-asn1-combinators-${version}";

  src = fetchzip {
    url = "https://github.com/mirleft/ocaml-asn1-combinators/archive/${version}.tar.gz";
    sha256 = "13vpdgcyph4vq3gcp8b16756s4nz3crpxhxfhcqgc1ffz61gc0h5";
  };

  buildInputs = [ ocaml findlib ounit ];
  propagatedBuildInputs = [ cstruct zarith ];

  createFindlibDestdir = true;

  configureFlags = "--enable-tests";
  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = https://github.com/mirleft/ocaml-asn1-combinators;
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    platforms = ocaml.meta.platforms or [];
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    broken = stdenv.isi686; # https://github.com/mirleft/ocaml-asn1-combinators/issues/13
  };
}
