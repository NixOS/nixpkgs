{ lib, fetchFromGitHub, buildDunePackage
, base64, bos, core, lwt_react, ocamlgraph, rresult, tyxml
}:

buildDunePackage rec {
  pname = "bistro";
  version = "0.5.0";
  src = fetchFromGitHub {
    owner = "pveber";
    repo = pname;
    rev = "v${version}";
    sha256 = "114gq48cpj2mvycypa9lfyqqb26wa2gkdfwkcqhnx7m6sdwv9a38";
  };

  propagatedBuildInputs = [ base64 bos core lwt_react ocamlgraph rresult tyxml ];

  minimumOCamlVersion = "4.07";

  meta = {
    inherit (src.meta) homepage;
    description = "Build and execute typed scientific workflows";
    maintainers = [ lib.maintainers.vbgl ];
    license = lib.licenses.gpl2;
  };
}
