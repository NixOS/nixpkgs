{ stdenv, fetchgit, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-re-1.3.0";

  src = fetchgit {
    url = https://github.com/ocaml/ocaml-re.git;
    rev = "refs/tags/${name}";
    sha256 = "1h8hz0dbjp8l39pva2js380c8bsm8rb4v326l62rkrdv8jvyh6bx";
  };

  buildInputs = [ ocaml findlib ];

  configurePhase = "ocaml setup.ml -configure --prefix $out";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/ocaml/ocaml-re;
    platforms = ocaml.meta.platforms;
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = stdenv.lib.licenses.lgpl2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
