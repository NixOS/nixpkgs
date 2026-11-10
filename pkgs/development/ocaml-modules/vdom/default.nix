{
  lib,
  fetchurl,
  buildDunePackage,
  js_of_ocaml-compiler,
  gen_js_api,
  ojs,
}:

buildDunePackage (finalAttrs: {
  pname = "vdom";
  version = "0.4";
  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/LexiFi/ocaml-vdom/releases/download/${finalAttrs.version}/vdom-${finalAttrs.version}.tbz";
    hash = "sha256-MyFghu7u7WBcRYDIPnYVzHu1QBJmsCWgFPpHAiDREc0=";
  };

  nativeBuildInputs = [
    gen_js_api
  ];

  buildInputs = [
    gen_js_api
  ];

  propagatedBuildInputs = [
    js_of_ocaml-compiler
    ojs
  ];

  meta = {
    homepage = "https://github.com/LexiFi/ocaml-vdom";
    description = "Elm architecture and (V)DOM for OCaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jayesh-bhoot ];
  };
})
