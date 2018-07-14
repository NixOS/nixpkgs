{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder
, ocaml-compiler-libs, ocaml-migrate-parsetree, ppx_derivers, stdio
}:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "ocaml${ocaml.version}-ppxlib-${version}";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppxlib";
    rev = version;
    sha256 = "0csp49jh7zgjnqh46mxbf322whlbmgy7v1a12nvxh97qg6i5fvsy";
  };

  buildInputs = [ ocaml findlib jbuilder ];

  propagatedBuildInputs = [
    ocaml-compiler-libs ocaml-migrate-parsetree ppx_derivers stdio
  ];

  buildPhase = "jbuilder build";

  inherit (jbuilder) installPhase;

  meta = {
    description = "Comprehensive ppx tool set";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    inherit (ocaml.meta) platforms;
  };

}
