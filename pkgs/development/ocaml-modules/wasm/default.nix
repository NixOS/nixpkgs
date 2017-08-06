{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "wasm is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-wasm-${version}";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "spec";
    rev = "v${version}";
    sha256 = "0l67w1dmhgzrhmw3pw2w35h54imax0zdpa9yyqppzzbagxgn87kn";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  makeFlags = [ "-C" "interpreter" ];

  createFindlibDestdir = true;

  meta = {
    description = "An OCaml library to read and write Web Assembly (wasm) files and manipulate their AST";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };
}
