{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner, seq, stdlib-shims }:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "fmt is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.8.6";
  pname = "ocaml${ocaml.version}-fmt";

  src = fetchurl {
    url = "https://erratique.ch/software/fmt/releases/fmt-${version}.tbz";
    sha256 = "1jlw5izgvqw1adzqi87rp0383j0vj52wmacy3rqw87vxkf7a3xin";
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
