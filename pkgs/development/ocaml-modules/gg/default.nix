{ stdenv, fetchurl, ocaml, findlib, opam }:

let
  inherit (stdenv.lib) getVersion versionAtLeast;

  pname = "gg";
  version = "0.9.1";
  webpage = "http://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.01.0";

stdenv.mkDerivation rec {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0czj41sr8jsivl3z8wyblf9k971j3kx2wc3s0c1nhzcc8allg9i2";
  };

  buildInputs = [ ocaml findlib opam ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";

  installPhase = ''
    opam-installer --script --prefix=$out ${pname}.install | sh
    ln -s $out/lib/${pname} $out/lib/ocaml/${getVersion ocaml}/site-lib/${pname}
  '';

  meta = with stdenv.lib; {
    description = "Basic types for computer graphics in OCaml";
    longDescription = ''
      Gg is an OCaml module providing basic types for computer graphics. It
      defines types and functions for floats, vectors, points, sizes,
      matrices, quaternions, axis aligned boxes, colors, color spaces, and
      raster data.
    '';
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
