{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, psq }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-lru-${version}";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/pqwy/lru/releases/download/v${version}/lru-${version}.tbz";
    sha256 = "0bd7js9rrma1fjjjjc3fgr9l5fjbhgihx2nsaf96g2b35iiaimd0";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  propagatedBuildInputs = [ psq ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = "https://github.com/pqwy/lru";
    description = "Scalable LRU caches for OCaml";
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    license = stdenv.lib.licenses.isc;
    inherit (ocaml.meta) platforms;
  };
}
