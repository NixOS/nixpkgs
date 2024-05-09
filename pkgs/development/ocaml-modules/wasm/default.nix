{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

if lib.versionOlder ocaml.version "4.08"
then throw "wasm is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-wasm";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "spec";
    rev = "opam-${version}";
    hash = "sha256-5eo8MIui2GxRS5X9az0NlLGZfxi5KGsTI/EaP6m/zts=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  strictDeps = true;

  # x86_64-unknown-linux-musl-ld: -r and -pie may not be used together
  hardeningDisable = lib.optional stdenv.hostPlatform.isStatic "pie";

  makeFlags = [ "-C" "interpreter" ];

  createFindlibDestdir = true;

  postInstall = ''
    mkdir $out/bin
    cp -L interpreter/wasm $out/bin
  '';

  meta = {
    description = "An executable and OCaml library to run, read and write Web Assembly (wasm) files and manipulate their AST";
    mainProgram = "wasm";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/WebAssembly/spec/tree/master/interpreter";
    inherit (ocaml.meta) platforms;
  };
}
