{ stdenv, buildOcaml, fetchFromGitHub, ocaml-migrate-parsetree }:

buildOcaml rec {
  name = "ppx_tools_versioned";
  version = "5.0alpha";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "let-def";
    repo = "ppx_tools_versioned";
    rev = version;
    sha256 = "0sa3w0plpa0s202s9yjgz7dbk32xd2s6fymkjijrhj4lkvh08mba";
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
