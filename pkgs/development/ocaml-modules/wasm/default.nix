{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "wasm is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-wasm-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "spec";
    rev = "v${version}";
    sha256 = "0r0wj31s2yg4vn4hyw2afc8wp8b0k3q130yiypwq3dlvfxrr70m6";
  };

  buildInputs = [ ocaml findlib ocamlbuild ];

  makeFlags = [ "-C" "interpreter" ];

  createFindlibDestdir = true;

  postInstall = ''
    mkdir $out/bin
    cp -L interpreter/wasm $out/bin
  '';

  meta = {
    description = "An executable and OCaml library to run, read and write Web Assembly (wasm) files and manipulate their AST";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    homepage = https://github.com/WebAssembly/spec/tree/master/interpreter;
    inherit (ocaml.meta) platforms;
  };
}
