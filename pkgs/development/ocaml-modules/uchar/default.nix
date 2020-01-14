{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opaline, withShared ? true }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-uchar-0.0.2";

  src = fetchurl {
    url = https://github.com/ocaml/uchar/releases/download/v0.0.2/uchar-0.0.2.tbz;
    sha256 = "1w2saw7zanf9m9ffvz2lvcxvlm118pws2x1wym526xmydhqpyfa7";
  };

  nativeBuildInputs = [ ocaml ocamlbuild findlib ];
  buildInputs = [ findlib ocaml ocamlbuild ];
  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=${if withShared then "true" else "false"}";
  installPhase = "${opaline}/bin/opaline -libdir $OCAMLFIND_DESTDIR";
  configurePlatforms = [];

  meta = {
    description = "Compatibility library for OCaml’s Uchar module";
    inherit (ocaml.meta) platforms license;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
