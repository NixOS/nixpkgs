{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uucp, uutf, cmdliner }:

let
  pname = "uuseg";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "14.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256:1g9zyzjkhqxgbb9mh3cgaawscwdazv6y8kdqvmy6yhnimmfqv25p";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [  topkg cmdliner  uutf ];
  propagatedBuildInputs = [ uucp ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml library for segmenting Unicode text";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
