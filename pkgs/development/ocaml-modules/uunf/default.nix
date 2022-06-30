{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, cmdliner }:
let
  pname = "uunf";
  webpage = "https://erratique.ch/software/${pname}";
  version = "14.0.0";
in

if lib.versionOlder ocaml.version "4.03"
then throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256:17wv0nm3vvwcbzb1b09akw8jblmigyhbfmh1sy9lkb5756ni94a2";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg uutf cmdliner ];

  propagatedBuildInputs = [ uchar ];

  strictDeps = true;

  prePatch = lib.optionalString stdenv.isAarch64 "ulimit -s 16384";

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = webpage;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "unftrip";
    inherit (ocaml.meta) platforms;
  };
}
