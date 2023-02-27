{ lib
, buildDunePackage
, fetchFromGitHub
, fetchpatch
, angstrom
, cmdliner
, core
, core_bench
, core_unix
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
  version = "1.5.2";

  minimalOCamlVersion = "4.10";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "mldoc";
    rev = "v${version}";
    hash = "sha256-FiBlgTTGL5TQkbhpkOCKtBgDDxDs4S88Ps+XAHcNsJ4=";
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
