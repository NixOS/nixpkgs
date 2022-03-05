{ stdenv, lib, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

if !lib.versionAtLeast ocaml.version "4.02"
|| lib.versionOlder "4.13" ocaml.version
then throw "wasm is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-wasm";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "spec";
    rev = "opam-${version}";
    sha256 = "1kp72yv4k176i94np0m09g10cviqp2pnpm7jmiq6ik7fmmbknk7c";
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
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/WebAssembly/spec/tree/master/interpreter";
    inherit (ocaml.meta) platforms;
  };
}
