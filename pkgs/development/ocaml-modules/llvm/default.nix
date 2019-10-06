{ stdenv, fetchpatch, python, cmake, llvm, ocaml, findlib, ctypes }:

let version = stdenv.lib.getVersion llvm; in

stdenv.mkDerivation {
  pname = "ocaml-llvm";
  inherit version;

  inherit (llvm) src;

  buildInputs = [ python cmake ocaml findlib ctypes ];
  propagatedBuildInputs = [ llvm ];

  patches = [ (fetchpatch {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/604f1b24af6c426e0ff3a296daae3fff38ff9e95/packages/llvm/llvm.3.9/files/cmake.patch;
    sha256 = "1fcc6ylfiw1npdhx7mrsj7h0dx7cym7i9664kpr76zqazb52ikm9";
  })];

  cmakeFlags = [ "-DLLVM_OCAML_OUT_OF_TREE=TRUE" ];

  buildFlags = "ocaml_all";

  installFlags = "-C bindings/ocaml";

  postInstall = ''
    mv $out/lib/ocaml $out/ocaml
    mkdir -p $OCAMLFIND_DESTDIR/
    mv $out/ocaml $OCAMLFIND_DESTDIR/llvm
    mv $OCAMLFIND_DESTDIR/llvm/META{.llvm,}
  '';

  passthru = {
    inherit llvm;
  };

  meta = {
    inherit (llvm.meta) license homepage;
    platforms = ocaml.meta.platforms or [];
    description = "OCaml bindings distributed with LLVM";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };

}
