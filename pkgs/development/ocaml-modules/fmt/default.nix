{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner, seq, stdlib-shims }:

if !lib.versionAtLeast ocaml.version "4.05"
then throw "fmt is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  version = "0.8.9";
  pname = "ocaml${ocaml.version}-fmt";

  src = fetchurl {
    url = "https://erratique.ch/software/fmt/releases/fmt-${version}.tbz";
    sha256 = "0gkkkj4x678vxdda4xaw2dd44qjacavsvn5nx8gydfwah6pjbkxk";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];
  propagatedBuildInputs = [ cmdliner seq stdlib-shims ];

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
