{ buildDunePackage
, ocaml
, lib
, ppxlib
, fetchFromGitHub
, ojs
, js_of_ocaml-compiler
, nodejs
}:

buildDunePackage rec {
  pname = "gen_js_api";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "LexiFi";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0FKKYPbSBza/Q6oZniq/UHi5zBjD/i7j5ds3ZDWkBTs=";
  };

  minimalOCamlVersion = "4.11";

  propagatedBuildInputs = [ ojs ppxlib ];
  nativeCheckInputs = [ js_of_ocaml-compiler nodejs ];
  doCheck = lib.versionAtLeast ocaml.version "4.13";

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
