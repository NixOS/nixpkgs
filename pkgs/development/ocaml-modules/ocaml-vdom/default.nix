{
  lib,
  fetchurl,
  buildDunePackage,
  js_of_ocaml-compiler,
  gen_js_api,
  ojs,
}:

buildDunePackage rec {
  pname = "ocaml-vdom";
  version = "0.2";
  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/LexiFi/ocaml-vdom/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-FVR0WubW9VJBGVtVaXdJ+O/ghq0w5+BuItFWXkuVYL8=";
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
}
