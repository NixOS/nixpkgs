{ stdenv, lib, fetchzip, ocaml, findlib, ocamlbuild, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-mparser-1.2.3";
  src = fetchFromGitHub {
    owner = "comby-tools";
    repo = "mparser";
    rev = "8de1895f6f4e48e19280ec37f3ec29776363d411";
    sha256 = "1h09x5xw70wl0jiwyga7dbwl9bh4ai7dn91z9zyzyn5aqw3cgr62";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  configurePhase = "ocaml setup.ml -configure";
  buildPhase = "ocaml setup.ml -build";
  installPhase = "ocaml setup.ml -install";

  createFindlibDestdir = true;

  meta = {
    description = "A simple monadic parser combinator OCaml library";
    license = lib.licenses.lgpl21Plus;
    homepage = "https://github.com/cakeplus/mparser";
    maintainers = [ lib.maintainers.vbgl ];
    inherit (ocaml.meta) platforms;
  };
}
