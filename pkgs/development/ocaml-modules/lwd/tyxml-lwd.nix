{
  lib,
  buildDunePackage,
  js_of_ocaml,
  js_of_ocaml-ppx,
  lwd,
  tyxml,
}:

buildDunePackage {
  pname = "tyxml-lwd";

  inherit (lwd) version src;

  buildInputs = [ js_of_ocaml-ppx ];
  propagatedBuildInputs = [
    js_of_ocaml
    lwd
    tyxml
  ];

  meta = {
    description = "Make reactive webpages in Js_of_ocaml using Tyxml and Lwd";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
