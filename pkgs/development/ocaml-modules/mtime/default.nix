{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.08")
  "mtime is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-mtime";
  version = "2.0.0";

  src = fetchurl {
    url = "https://erratique.ch/software/mtime/releases/mtime-${version}.tbz";
    sha256 = "Pz2g6gBts0RlsDCE3npYqxWg8W9HgoxQC+U63fHgROs=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "Monotonic wall-clock time for OCaml";
    homepage = "https://erratique.ch/software/mtime";
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
