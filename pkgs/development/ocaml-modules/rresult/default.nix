{
  stdenv,
  lib,
  fetchurl,
  ocaml,
  findlib,
  ocamlbuild,
  topkg,
  result,
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-rresult";
  version = "0.7.0";
  src = fetchurl {
    url = "https://erratique.ch/software/rresult/releases/rresult-${version}.tbz";
    sha256 = "sha256-Eap/W4NGDmBDHjFU4+MsBx1G4VHqV2DPJDd4Bb+XVUA=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
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
    broken = !(lib.versionAtLeast ocaml.version "4.07");
  };
}
