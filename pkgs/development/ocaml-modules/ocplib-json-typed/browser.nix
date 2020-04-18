{ buildDunePackage, ocplib-json-typed, js_of_ocaml }:

buildDunePackage {
  pname = "ocplib-json-typed-browser";
  inherit (ocplib-json-typed) version src;

  propagatedBuildInputs = [ ocplib-json-typed js_of_ocaml ];

  meta = {
    description = "A Json_repr interface over JavaScript's objects";
    inherit (ocplib-json-typed.meta) homepage license maintainers;
  };
}

