{ stdenv, lib, fetchurl, ocaml, findlib, ocamlbuild, topkg, result }:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-rresult";
  version = "0.6.0";
  src = fetchurl {
    url = "https://erratique.ch/software/rresult/releases/rresult-${version}.tbz";
    sha256 = "1k69a3gvrk7f2cshwjzvk7818f0bwxhacgd14wxy6d4gmrggci86";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  propagatedBuildInputs = [ result ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = {
    license = lib.licenses.isc;
    homepage = "https://erratique.ch/software/rresult";
    description = "Result value combinators for OCaml";
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
