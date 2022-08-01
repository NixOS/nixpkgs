{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner_1_1, seq, stdlib-shims }:

if lib.versionOlder ocaml.version "4.05"
then throw "fmt is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "ocaml${ocaml.version}-fmt";

  src = fetchurl {
    url = "https://erratique.ch/software/fmt/releases/fmt-${version}.tbz";
    sha256 = "0q8j2in2473xh7k4hfgnppv9qy77f2ih89yp6yhpbp92ba021yzi";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ cmdliner_1_1 topkg ];
  propagatedBuildInputs = [ seq stdlib-shims ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = "https://erratique.ch/software/fmt";
    license = licenses.isc;
    description = "OCaml Format pretty-printer combinators";
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
  };
}
