{ stdenv, fetchpatch, python, cmake, llvm, ocaml, findlib, ctypes }:

let version = stdenv.lib.getVersion llvm; in

stdenv.mkDerivation {
  pname = "ocaml-llvm";
  inherit version;

  inherit (llvm) src;

  buildInputs = [ python cmake ocaml findlib ctypes ];
  propagatedBuildInputs = [ llvm ];

  patches = [ (fetchpatch {
    url = https://raw.githubusercontent.com/ocaml/opam-repository/2bdc193f5a9305ea93bf0f0dfc1fbc327c8b9306/packages/llvm/llvm.7.0.0/files/fix-shared.patch;
    sha256 = "1p98j3b1vrryfn1xa7i50m6mmm4dyw5ldafq6kyh9sfmdihz4zsx";
  })];

  cmakeFlags = [
    "-DLLVM_OCAML_OUT_OF_TREE=TRUE"
    "-DLLVM_OCAML_INSTALL_PATH=${placeholder "out"}/ocaml"
    "-DLLVM_OCAML_EXTERNAL_LLVM_LIBDIR=${stdenv.lib.getLib llvm}/lib"
  ];

  buildFlags = [ "ocaml_all" ];

  installFlags = [ "-C" "bindings/ocaml" ];

  postInstall = ''
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
