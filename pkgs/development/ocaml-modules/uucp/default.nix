{ stdenv, fetchurl, ocaml, findlib, opam }:

let
  inherit (stdenv.lib) getVersion versionAtLeast;

  pname = "uucp";
  version = "0.9.1";
  webpage = "http://erratique.ch/software/${pname}";
in

assert versionAtLeast (getVersion ocaml) "4.00";

stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0mbrh5fi2b9a4bl71p7hfs0wwbw023ww44n20x0syxn806wjlrkm";
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
    description = "An OCaml library providing efficient access to a selection of character properties of the Unicode character database";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms;
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
