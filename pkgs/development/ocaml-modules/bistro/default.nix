{ lib, fetchFromGitHub, buildDunePackage
, core, lwt ? ocaml_lwt, ocaml_lwt, ocamlgraph, rresult, tyxml
}:

buildDunePackage rec {
  pname = "bistro";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bxnggm4nkyl2iqwj4f5afw8lj5miq2rqsc9qfrlmg4g4rr3zh1c";
  };

  buildInputs = [ lwt ocamlgraph rresult tyxml ];

  propagatedBuildInputs = [ core ];

  minimumOCamlVersion = "4.04";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
