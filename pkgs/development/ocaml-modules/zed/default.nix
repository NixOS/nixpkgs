{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, camomile, react, dune }:

let param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then
  {
    version = "1.6";
    sha256 = "00hhxcjf3bj3w2qm8nzs9x6vrqkadf4i0277s5whzy2rmiknj63v";
    buildInputs = [ dune ];
    extra = {
     buildPhase = "dune build -p zed";
     inherit (dune) installPhase; };
  } else {
    version = "1.4";
    sha256 = "0d8qfy0qiydrrqi8qc9rcwgjigql6vx9gl4zp62jfz1lmjgb2a3w";
    buildInputs = [];
    extra = { createFindlibDestdir = true; };
  }
; in

stdenv.mkDerivation (rec {
  inherit (param) version;
  name = "ocaml-zed-${version}";

  src = fetchzip {
    url = "https://github.com/diml/zed/archive/${version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ocamlbuild ] ++ param.buildInputs;

  propagatedBuildInputs = [ react camomile ];

  meta = {
    description = "Abstract engine for text edition in OCaml";
    longDescription = ''
    Zed is an abstract engine for text edition. It can be used to write text editors, edition widgets, readlines, ...

    Zed uses Camomile to fully support the Unicode specification, and implements an UTF-8 encoded string type with validation, and a rope datastructure to achieve efficient operations on large Unicode buffers. Zed also features a regular expression search on ropes.

    To support efficient text edition capabilities, Zed provides macro recording and cursor management facilities.
    '';
    homepage = https://github.com/diml/zed;
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
} // param.extra)
