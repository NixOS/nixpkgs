{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-stdint-${version}";
  version = "0.3.0";
  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-stdint";
    rev = version;
    sha256 = "18nh23yx4ghgq7mjf4mdyq8kj1fdw5d0abw919s8n4mv21cmpwia";
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
