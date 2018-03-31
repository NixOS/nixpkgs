{ stdenv, fetchurl, ocaml, ocamlbuild, opam }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-uchar-0.0.2";

  src = fetchurl {
    url = https://github.com/ocaml/uchar/releases/download/v0.0.2/uchar-0.0.2.tbz;
    sha256 = "1w2saw7zanf9m9ffvz2lvcxvlm118pws2x1wym526xmydhqpyfa7";
  };

  unpackCmd = "tar xjf $src";
  buildInputs = [ ocaml ocamlbuild opam ];
  buildPhase = "ocaml pkg/build.ml native=true native-dynlink=true";
  installPhase = ''
    opam-installer --script --prefix=$out uchar.install > install.sh
    sh install.sh
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/
    ln -s $out/lib/uchar $out/lib/ocaml/${ocaml.version}/site-lib/
  '';


  meta = {
    description = "Compatibility library for OCaml’s Uchar module";
    inherit (ocaml.meta) platforms license;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
