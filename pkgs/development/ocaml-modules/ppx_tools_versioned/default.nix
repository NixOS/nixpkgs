{ lib, fetchFromGitHub, buildDunePackage, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_tools_versioned";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "0c735w9mq49dmvkdw9ahfwh0icsk2sbhnfwmdhpibj86phfm17yj";
  };

  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  meta = with lib; {
    homepage = "https://github.com/let-def/ppx_tools_versioned";
    description = "Tools for authors of syntactic tools (such as ppx rewriters)";
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
  };
}
