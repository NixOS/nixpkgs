{
  lib,
  stdenv,
  fetchFromGitHub,
  menhir,
  odoc,
  buildDunePackage,
}:
buildDunePackage rec {
  pname = "wasm";
  version = "2.0.2";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "spec";
    tag = "opam-${version}";
    hash = "sha256-RbVGW6laC3trP6IhtA2tLrAYVbx0Oucox9FgoEvs6LQ=";
  };

  postUnpack = ''
    cd "$sourceRoot/interpreter"
    export sourceRoot=$PWD
  '';

  nativeBuildInputs = [
    menhir
    odoc
  ];

  meta = {
    description = "Library to read and write WebAssembly (Wasm) files and manipulate their AST";
    mainProgram = "wasm";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/WebAssembly/spec/tree/main/interpreter";
  };
}
