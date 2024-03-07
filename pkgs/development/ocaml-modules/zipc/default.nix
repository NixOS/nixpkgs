{ lib, stdenv, fetchurl
, ocaml, findlib, ocamlbuild, topkg, cmdliner
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.14")
  "zipc is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-zipc";
  version = "0.1.0";

  src = fetchurl {
    url = "https://erratique.ch/software/zipc/releases/zipc-${version}.tbz";
    hash = "sha256-vU4AGW1MjQ31xjwvyRKSn1AwS0X6gjLvaJGYKqzFRpk=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml findlib ocamlbuild
  ];

  buildInputs = [ cmdliner topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    description = "ZIP archive and deflate codec for OCaml";
    homepage = "https://erratique.ch/software/zipc";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
