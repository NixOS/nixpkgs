{ lib, stdenv, fetchFromGitHub, which, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "eff";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "matijapretnar";
    repo = "eff";
    rev = "v${version}";
    sha256 = "1fslfj5d7fhj3f7kh558b8mk5wllwyq4rnhfkyd96fpy144sdcka";
  };

  postPatch = ''
    substituteInPlace setup.ml --replace js_of_ocaml.ocamlbuild js_of_ocaml-ocamlbuild
  '';

  strictDeps = true;

  nativeBuildInputs = [ which ] ++ (with ocamlPackages; [
    ocaml findlib ocamlbuild menhir
  ]);

  buildInputs = with ocamlPackages; [ js_of_ocaml js_of_ocaml-ocamlbuild ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    homepage = "https://www.eff-lang.org";
    description = "A functional programming language based on algebraic effects and their handlers";
    longDescription = ''
      Eff is a functional language with handlers of not only exceptions,
      but also of other computational effects such as state or I/O. With
      handlers, you can simply implement transactions, redirections,
      backtracking, multi-threading, and much more...
    '';
    license = licenses.bsd2;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
