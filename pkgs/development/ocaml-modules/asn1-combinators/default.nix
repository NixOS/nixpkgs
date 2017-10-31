{ stdenv, buildOcaml, fetchFromGitHub, ocaml, findlib, cstruct, zarith, ounit, result, topkg, opam }:

let ocamlFlags = "-I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/"; in

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

  buildInputs = [ ocaml findlib ounit topkg opam ];
  propagatedBuildInputs = [ result cstruct zarith ];

  createFindlibDestdir = true;

  buildPhase = "ocaml ${ocamlFlags} pkg/pkg.ml build --tests true";

  installPhase = ''
    opam-installer --script --prefix=$out | sh
    ln -s $out/lib/asn1-combinators $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  doCheck = true;
  checkPhase = "ocaml ${ocamlFlags} pkg/pkg.ml test";

  meta = {
    homepage = https://github.com/mirleft/ocaml-asn1-combinators;
    description = "Combinators for expressing ASN.1 grammars in OCaml";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
