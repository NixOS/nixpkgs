{ lib, fetchurl, fetchpatch, buildDunePackage, js_of_ocaml, js_of_ocaml-ppx, lwd, tyxml }:

buildDunePackage {
  pname = "tyxml-lwd";

  inherit (lwd) version src;

  # Compatibility with latest Tyxml (4.6.x)
  patches = fetchpatch {
    url = "https://github.com/let-def/lwd/commit/7f3364ec593b5ccf0d0294b97bcd1e28e4164691.patch";
    hash = "sha256-W1HjExZxDKRwsrB9ZTkvHTMKO0K5iZl+FrNqPs6BPGU=";
  };

  minimalOCamlVersion = "4.08";

  buildInputs = [ js_of_ocaml-ppx ];
  propagatedBuildInputs = [ js_of_ocaml lwd tyxml ];

  meta = with lib; {
    description = "Make reactive webpages in Js_of_ocaml using Tyxml and Lwd";
    license = licenses.mit;
    maintainers = [ maintainers.alizter ];
    homepage = "https://github.com/let-def/lwd";
  };
}
