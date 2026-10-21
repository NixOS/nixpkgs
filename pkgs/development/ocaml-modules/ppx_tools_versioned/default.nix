{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocaml-migrate-parsetree,
}:

buildDunePackage (finalAttrs: {
  pname = "ppx_tools_versioned";
  version = "5.4.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = "ppx_tools_versioned";
    rev = finalAttrs.version;
    hash = "sha256-xsTW7LKxv3pTsRI/KEuAsTWife4t3AtdgZ5v/j2Rlh4=";
  };

  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  meta = {
    homepage = "https://github.com/let-def/ppx_tools_versioned";
    description = "Tools for authors of syntactic tools (such as ppx rewriters)";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
