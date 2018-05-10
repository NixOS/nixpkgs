{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-stdint-${version}";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-stdint";
    rev = version;
    sha256 = "1xjzqq13m7cqrfwa6vcwxirm17w8bx025dgnjqjgd3k2lxfgd1j7";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];
  configurePhase = "ocaml setup.ml -configure --prefix $out";

  createFindlibDestdir = true;

  meta = {
    description = "Various signed and unsigned integers for OCaml";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.gebner ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
