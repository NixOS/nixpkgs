{ lib, fetchurl, buildDunePackage, ocaml, js_of_ocaml, ppxlib, js_of_ocaml-ppx, gen_js_api }:

let
  owner = "mnxn";
in
buildDunePackage rec {
  pname = "promise_jsoo";
  version = "0.3.1";
  minimumOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/${owner}/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "00pjnsbv0yv3hhxbbl8dsljgr95kjgi9w8j1x46gjyxg9zayrxzl";
  };

  buildInputs = [
    js_of_ocaml
    ppxlib
    js_of_ocaml-ppx
    gen_js_api
  ];

  meta = {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Js_of_ocaml bindings to JS Promises with supplemental functions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jayesh-bhoot ];
  };
}

