{ lib, fetchurl, buildDunePackage, ocaml, js_of_ocaml, ppxlib, js_of_ocaml-ppx, gen_js_api, ojs }:

buildDunePackage rec {
  pname = "promise_jsoo";
  version = "0.3.1";
  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mnxn/promise_jsoo/releases/download/v${version}/promise_jsoo-v${version}.tbz";
    sha256 = "00pjnsbv0yv3hhxbbl8dsljgr95kjgi9w8j1x46gjyxg9zayrxzl";
  };

  buildInputs = [
    ppxlib
    js_of_ocaml-ppx
    gen_js_api
  ];

  propagatedBuildInputs = [
    js_of_ocaml
    ojs
  ];

  meta = {
    homepage = "https://github.com/mnxn/promise_jsoo";
    description = "Js_of_ocaml bindings to JS Promises with supplemental functions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jayesh-bhoot ];
  };
}
