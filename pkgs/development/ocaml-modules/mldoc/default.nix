{ lib
, buildDunePackage
, fetchFromGitHub
, fetchpatch
, angstrom
, cmdliner
, core
, core_bench
, core_unix ? null
, js_of_ocaml
, js_of_ocaml-ppx
, ppx_deriving_yojson
, uri
, yojson
, lwt
, xmlm
}:
let
  angstrom' = angstrom.overrideAttrs (attrs: {
    patches = attrs.patches or [ ] ++ [
      # mldoc requires Angstrom to expose `unsafe_lookahead`
      (fetchpatch {
        url = "https://github.com/logseq/angstrom/commit/bbe36c99c13678937d4c983a427e02a733d6cc24.patch";
        sha256 = "sha256-RapY1QJ8U0HOqJ9TFDnCYB4tFLFuThESzdBZqjYuDUA=";
      })
    ];
  });
  uri' = uri.override { angstrom = angstrom'; };
in
buildDunePackage rec {
  pname = "mldoc";
  version = "1.5.6";

  minimalOCamlVersion = "4.10";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "mldoc";
    rev = "2a700b2e4797e47505f423fd47dc07372bd7b04e"; # version not tagged
    hash = "sha256-OS06fb/Nz8grztFEVwWiqsQQt2PQjqcgQFxQuAEYC54=";
  };

  buildInputs = [
    cmdliner
    core
    core_bench
    core_unix
    js_of_ocaml
    js_of_ocaml-ppx
    lwt
  ];

  propagatedBuildInputs = [
    angstrom'
    uri'
    yojson
    ppx_deriving_yojson
    xmlm
  ];

  meta = with lib; {
    homepage = "https://github.com/logseq/mldoc";
    description = "Another Emacs Org-mode and Markdown parser";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ marsam ];
  };
}
