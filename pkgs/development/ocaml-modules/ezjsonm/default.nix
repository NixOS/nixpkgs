{ stdenv, fetchzip, ocaml, findlib, dune, jsonm, hex, sexplib }:

let version = "0.6.0"; in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-ezjsonm-${version}";

  src = fetchzip {
    url = "https://github.com/mirage/ezjsonm/archive/${version}.tar.gz";
    sha256 = "18g64lhai0bz65b9fil12vlgfpwa9b5apj7x6d7n4zzm18qfazvj";
  };

  buildInputs = [ ocaml findlib dune ];
  propagatedBuildInputs = [ jsonm hex sexplib ];

  buildPhase = "dune build -p ezjsonm";

  inherit (dune) installPhase;

  meta = {
    description = "An easy interface on top of the Jsonm library";
    homepage = https://github.com/mirage/ezjsonm;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
