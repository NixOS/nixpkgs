{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner, seq, stdlib-shims }:

if !stdenv.lib.versionAtLeast ocaml.version "4.05"
then throw "fmt is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.8.8";
  pname = "ocaml${ocaml.version}-fmt";

  src = fetchurl {
    url = "https://erratique.ch/software/fmt/releases/fmt-${version}.tbz";
    sha256 = "1iy0rwknd302mr15328g805k210xyigxbija6fzqqfzyb43azvk4";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ findlib topkg cmdliner ];
  propagatedBuildInputs = [ seq stdlib-shims ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    homepage = "https://erratique.ch/software/fmt";
    license = stdenv.lib.licenses.isc;
    description = "OCaml Format pretty-printer combinators";
    inherit (ocaml.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
