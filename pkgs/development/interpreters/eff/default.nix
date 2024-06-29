{ lib, fetchFromGitHub, ocamlPackages }:

let
  inherit (ocamlPackages) buildDunePackage js_of_ocaml menhir;
in

buildDunePackage rec {
  pname = "eff";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "matijapretnar";
    repo = "eff";
    rev = "v${version}";
    hash = "sha256-0U61y41CA0YaoNk9Hsj7j6eb2V6Ku3MAjW9lMEimiC0=";
  };

  nativeBuildInputs = [ menhir ];

  buildInputs = [ js_of_ocaml ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://www.eff-lang.org";
    description = "Functional programming language based on algebraic effects and their handlers";
    mainProgram = "eff";
    longDescription = ''
      Eff is a functional language with handlers of not only exceptions,
      but also of other computational effects such as state or I/O. With
      handlers, you can simply implement transactions, redirections,
      backtracking, multi-threading, and much more...
    '';
    license = licenses.bsd2;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
