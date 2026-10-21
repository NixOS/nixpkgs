{
  lib,
  fetchurl,
  buildDunePackage,
  js_of_ocaml,
  ppxlib,
  js_of_ocaml-ppx,
  gen_js_api,
  ojs,
}:

buildDunePackage (finalAttrs: {
  pname = "promise_jsoo";
  version = "0.3.1";
  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mnxn/promise_jsoo/releases/download/v${finalAttrs.version}/promise_jsoo-v${finalAttrs.version}.tbz";
    hash = "sha256-9Pfs1U+ve/kM6UEinuKTs6T8JNUN0bU6hGN7sJe28gI=";
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
})
