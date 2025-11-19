{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  topkg,
  ocamlbuild,
}:

let
  homepage = "https://erratique.ch/software/gg";
  version = "1.0.0";
in

stdenv.mkDerivation {

  pname = "ocaml${ocaml.version}-gg";
  inherit version;

  src = fetchurl {
    url = "${homepage}/releases/gg-${version}.tbz";
    sha256 = "sha256:0j7bpj8k17csnz6v6frkz9aycywsb7xmznnb31g8rbfk3626f3ci";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
    topkg
  ];
  buildInputs = [ topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "Basic types for computer graphics in OCaml";
    longDescription = ''
      Gg is an OCaml module providing basic types for computer graphics. It
      defines types and functions for floats, vectors, points, sizes,
      matrices, quaternions, axis aligned boxes, colors, color spaces, and
      raster data.
    '';
    inherit homepage;
    inherit (ocaml.meta) platforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
    broken = !(lib.versionAtLeast ocaml.version "4.08");
  };
}
