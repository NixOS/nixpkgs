{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, cmdliner }:
let
  pname = "uunf";
  webpage = "https://erratique.ch/software/${pname}";
  version = "14.0.0";
in

if !lib.versionAtLeast ocaml.version "4.03"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256:17wv0nm3vvwcbzb1b09akw8jblmigyhbfmh1sy9lkb5756ni94a2";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg uutf cmdliner ];

  propagatedBuildInputs = [ uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
