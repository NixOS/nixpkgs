{ lib
, buildDunePackage
, fetchFromGitHub
, fetchpatch
, angstrom
, cmdliner
, core
, core_bench
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
  version = "1.3.9";

  minimalOCamlVersion = "4.10";

  src = fetchFromGitHub {
    owner = "logseq";
    repo = "mldoc";
    rev = "v${version}";
    sha256 = "sha256-C5SeG10EoZixCWeBxw7U+isAR8UWd1jzHLdmbp//gAs=";
  };

  buildInputs = [
    cmdliner
    core
    core_bench
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
