{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, uutf }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-jsonm";
  version = "1.0.2";

  src = fetchurl {
    url = "https://erratique.ch/software/jsonm/releases/jsonm-${version}.tbz";
    hash = "sha256-6ikjn+tAUyAd8+Hm0nws4SOIKsRljhyL6plYvhGKe9Y=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ uutf ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "An OCaml non-blocking streaming codec to decode and encode the JSON data format";
    homepage = "https://erratique.ch/software/jsonm";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vbgl ];
    mainProgram = "jsontrip";
    inherit (ocaml.meta) platforms;
  };
}
