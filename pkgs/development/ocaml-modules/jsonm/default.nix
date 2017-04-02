{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, opam, uutf }:

let version = "1.0.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-jsonm-${version}";

  src = fetchurl {
    url = "http://erratique.ch/software/jsonm/releases/jsonm-${version}.tbz";
    sha256 = "1v3ln6d965lplj28snjdqdqablpp1kx8bw2cfx0m6i157mqyln62";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg opam ];
  propagatedBuildInputs = [ uutf ];

  unpackCmd = "tar xjf $src";

  createFindlibDestdir = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "An OCaml non-blocking streaming codec to decode and encode the JSON data format";
    homepage = http://erratique.ch/software/jsonm;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
