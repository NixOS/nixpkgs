{ stdenv, buildOcaml, fetchFromGitHub, ocaml-migrate-parsetree }:

buildOcaml rec {
  name = "ppx_tools_versioned";
  version = "5.0.1";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "ppx_tools_versioned";
    rev = version;
    sha256 = "1rpbxbhk3k7f61h7lr4qkllkc12gjpq0rg52q7i6hcrg2dxkhwh6";
  };

  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  createFindlibDestdir = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/let-def/ppx_tools_versioned;
    description = "Tools for authors of syntactic tools (such as ppx rewriters)";
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
  };
}
