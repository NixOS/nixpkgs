{ lib, fetchFromGitHub, buildDunePackage, ocaml-migrate-parsetree }:

buildDunePackage rec {
  pname = "ppx_tools_versioned";
  version = "5.4.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "ocaml-ppx";
    repo = pname;
    rev = version;
    sha256 = "07lnj4yzwvwyh5fhpp1dxrys4ddih15jhgqjn59pmgxinbnddi66";
  };

  propagatedBuildInputs = [ ocaml-migrate-parsetree ];

  meta = with lib; {
    homepage = "https://github.com/let-def/ppx_tools_versioned";
    description = "Tools for authors of syntactic tools (such as ppx rewriters)";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
