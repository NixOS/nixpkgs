{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  topkg,
  ocamlbuild,
  cmdliner,
}:

stdenv.mkDerivation rec {

  pname = "ocaml${ocaml.version}-b0";
  version = "0.0.5";

  src = fetchurl {
    url = "${meta.homepage}/releases/b0-${version}.tbz";
    sha256 = "sha256-ty04JQcP4RCme/VQw0ko2IBebWWX5cBU6nRTTeV1I/I=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [
    topkg
    cmdliner
  ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "Software construction and deployment kit";
    longDescription = ''
      WARNING this package is unstable and work in progress, do not depend on
      it.
      B0 describes software construction and deployments using modular and
      customizable definitions written in OCaml. B0 describes:
      * Build environments.
      * Software configuration, build and testing.
      * Source and binary deployments.
      * Software life-cycle procedures.
      B0 also provides the B00 build library which provides abitrary build
      abstraction with reliable and efficient incremental rebuilds. The B00
      library can be – and has been – used on its own to devise domain specific
      build systems.
    '';
    homepage = "https://erratique.ch/software/b0";
    inherit (ocaml.meta) platforms;
    license = licenses.isc;
    maintainers = [ maintainers.Julow ];
    broken = !(lib.versionAtLeast ocaml.version "4.08");
  };
}
