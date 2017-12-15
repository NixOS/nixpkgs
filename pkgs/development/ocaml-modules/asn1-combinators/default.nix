{ stdenv, buildOcaml, fetchFromGitHub, ocaml, findlib, cstruct, zarith, ounit, result, topkg }:

buildOcaml rec {
  name = "asn1-combinators";
  version = "0.1.3";

  minimumSupportedOcamlVersion = "4.01";

  src = fetchFromGitHub {
    owner  = "mirleft";
    repo   = "ocaml-asn1-combinators";
    rev    = "v${version}";
    sha256 = "0hpn049i46sdnv2i6m7r6m6ch0jz8argybh71wykbvcqdby08zxj";
  };

  buildInputs = [ ocaml findlib ounit topkg ];
  propagatedBuildInputs = [ result cstruct zarith ];

  createFindlibDestdir = true;

  buildPhase = "${topkg.run} build --tests true";

  inherit (topkg) installPhase;

  doCheck = true;
  checkPhase = "${topkg.run} test";

  meta = {
    homepage = https://github.com/mirleft/ocaml-asn1-combinators;
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
