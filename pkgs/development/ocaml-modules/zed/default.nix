{ stdenv, fetchzip, ocaml, findlib, camomile, ocaml_react }:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "ocaml-zed-${version}";

  src = fetchzip {
    url = "https://github.com/diml/zed/archive/${version}.tar.gz";
    sha256 = "0d8qfy0qiydrrqi8qc9rcwgjigql6vx9gl4zp62jfz1lmjgb2a3w";
  };

  buildInputs = [ ocaml findlib ocaml_react ];

  propagatedBuildInputs = [ camomile ];

  createFindlibDestdir = true;

  meta = {
    description = "Abstract engine for text edition in OCaml";
    longDescription = ''
    Zed is an abstract engine for text edition. It can be used to write text editors, edition widgets, readlines, ...

    Zed uses Camomile to fully support the Unicode specification, and implements an UTF-8 encoded string type with validation, and a rope datastructure to achieve efficient operations on large Unicode buffers. Zed also features a regular expression search on ropes.

    To support efficient text edition capabilities, Zed provides macro recording and cursor management facilities.
    '';
    homepage = https://github.com/diml/zed;
    license = stdenv.lib.licenses.bsd3;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
