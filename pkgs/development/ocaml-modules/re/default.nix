{ stdenv, fetchgit, ocaml, findlib }:

stdenv.mkDerivation rec {
  name = "ocaml-re-1.2.2";

  src = fetchgit {
    url = https://github.com/ocaml/ocaml-re.git;
    rev = "refs/tags/${name}";
    sha256 = "1556i1zc6nrg4hxlvidllfhkjwl6n74biyjbvjlby8304n84jrk7";
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
