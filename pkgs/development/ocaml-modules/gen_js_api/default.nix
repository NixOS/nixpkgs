{ buildDunePackage
, lib
, ppxlib
, fetchFromGitHub
, ojs
, js_of_ocaml-compiler
, nodejs
}:

buildDunePackage rec {
  pname = "gen_js_api";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "LexiFi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qx6if1avr484bl9x1h0cksdc6gqw5i4pwzdr27h46hppnnvi8y8";
  };

  minimalOCamlVersion = "4.08";

  propagatedBuildInputs = [ ojs ppxlib ];
  checkInputs = [ js_of_ocaml-compiler nodejs ];
  doCheck = true;

  meta = {
    homepage = "https://github.com/LexiFi/gen_js_api";
    description = "Easy OCaml bindings for JavaScript libraries";
    longDescription = ''
      gen_js_api aims at simplifying the creation of OCaml bindings for
      JavaScript libraries. Authors of bindings write OCaml signatures for
      JavaScript libraries and the tool generates the actual binding code with a
      combination of implicit conventions and explicit annotations.

      gen_js_api is to be used with the js_of_ocaml compiler.
    '';
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bcc32 ];
  };
}
