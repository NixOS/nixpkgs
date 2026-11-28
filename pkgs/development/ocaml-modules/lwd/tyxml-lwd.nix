{
  lib,
  buildDunePackage,
  fetchpatch,
  js_of_ocaml,
  js_of_ocaml-ppx,
  lwd,
  tyxml,
}:

buildDunePackage {
  pname = "tyxml-lwd";

  inherit (lwd) version src;

  patches = [
    # Compatibility with tyxml ≥ 5.0
    (fetchpatch {
      url = "https://github.com/let-def/lwd/commit/e226c443d590fdf6086bca397156f74c6a6d93e9.patch";
      includes = [ "lib/*" ];
      hash = "sha256-RQAX1wrdSYivkYjPNeBIevk8xbV9JJeMQIIa31TGTo8=";
    })
    (fetchpatch {
      url = "https://github.com/let-def/lwd/commit/29490b8dfd2df85e61e4b68a940ac7db613d1c44.patch";
      hash = "sha256-Khf8SXqdb+Zo+LoVe+POXmc77jd/chT9XgTJ73oAbdg=";
    })
  ];

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
