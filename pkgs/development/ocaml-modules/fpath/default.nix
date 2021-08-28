{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, astring }:

if !lib.versionAtLeast ocaml.version "4.03"
then throw "fpath is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-fpath-0.7.3";
  src = fetchurl {
    url = "https://erratique.ch/software/fpath/releases/fpath-0.7.3.tbz";
    sha256 = "03z7mj0sqdz465rc4drj1gr88l9q3nfs374yssvdjdyhjbqqzc0j";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  propagatedBuildInputs = [ astring ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "An OCaml module for handling file system paths with POSIX and Windows conventions";
    homepage = "https://erratique.ch/software/fpath";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
