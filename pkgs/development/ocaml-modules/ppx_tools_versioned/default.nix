{ stdenv, fetchFromGitHub, ocaml, findlib, ocaml-migrate-parsetree }:

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-ppx_tools_versioned-${version}";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "ppx_tools_versioned";
    rev = version;
    sha256 = "1c7kvca67qpyr4hiy492yik5x31lmkhyhy5wpl0l0fbx7fr7l624";
  };

  buildInputs = [ ocaml findlib ];

  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/let-def/ppx_tools_versioned;
    description = "Tools for authors of syntactic tools (such as ppx rewriters)";
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
  };
}
