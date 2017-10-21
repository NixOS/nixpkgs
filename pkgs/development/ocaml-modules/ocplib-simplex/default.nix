{ stdenv, fetchFromGitHub, autoreconfHook, ocaml, findlib }:

let
  pname = "ocplib-simplex";
  version = "0.3";
in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "OCamlPro-Iguernlala";
    repo = pname;
    rev = version;
    sha256 = "1fmz38w2cj9fny4adqqyil59dvndqkr59s7wk2gqs47r72b6sisa";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ocaml findlib ];

  createFindlibDestdir = true;

  meta = {
    description = "An OCaml library implementing a simplex algorithm, in a functional style, for solving systems of linear inequalities";
    homepage = https://github.com/OCamlPro-Iguernlala/ocplib-simplex;
    inherit (ocaml.meta) platforms;
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
