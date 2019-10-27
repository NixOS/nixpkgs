{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opaline }:

let
  inherit (stdenv.lib) getVersion versionAtLeast;

  pname = "gg";
  version = "0.9.1";
  webpage = "https://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.01.0";

stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0czj41sr8jsivl3z8wyblf9k971j3kx2wc3s0c1nhzcc8allg9i2";
  };

  buildInputs = [ ocaml findlib ocamlbuild opaline ];

  createFindlibDestdir = true;

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = "opaline -libdir $OCAMLFIND_DESTDIR";

  meta = with stdenv.lib; {
    description = "Basic types for computer graphics in OCaml";
    longDescription = ''
      Gg is an OCaml module providing basic types for computer graphics. It
      defines types and functions for floats, vectors, points, sizes,
      matrices, quaternions, axis aligned boxes, colors, color spaces, and
      raster data.
    '';
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
