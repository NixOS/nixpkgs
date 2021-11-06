{ stdenv, lib, fetchurl, fetchpatch, ocaml, findlib, ocaml_pcre }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-inifiles-1.2";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/o/ocaml-inifiles/ocaml-inifiles_1.2.orig.tar.gz";
    sha256 = "0jhzgiypmh6hwsv1zpiq77fi0cvcmwbiy5x0yg7mz6p3dh1dmkns";
  };

  patches = [ (fetchpatch {
    url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/ocaml-inifiles/ocaml-inifiles.1.2/files/ocaml-inifiles.diff";
    sha256 = "037kk3172s187w8vwsykdxlpklxzc7m7np57sapk499d8adzdgwn";
  })];

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ ocaml_pcre ];

  buildFlags = [ "all" "opt" ];

  createFindlibDestdir = true;

  meta = {
    description = "A small OCaml library to read and write .ini files";
    license = lib.licenses.lgpl21Plus;
    inherit (ocaml.meta) platforms;
  };
}
