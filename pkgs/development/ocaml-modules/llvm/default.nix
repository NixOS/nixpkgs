{ stdenv, lib, fetchpatch, python, cmake, libllvm, ocaml, findlib, ctypes }:

let version = lib.getVersion libllvm; in

stdenv.mkDerivation {
  pname = "ocaml-llvm";
  inherit version;

  inherit (libllvm) src;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ python ocaml findlib ctypes ];
  propagatedBuildInputs = [ libllvm ];

  patches = [ (fetchpatch {
    url = "https://raw.githubusercontent.com/ocaml/opam-repository/2bdc193f5a9305ea93bf0f0dfc1fbc327c8b9306/packages/llvm/llvm.7.0.0/files/fix-shared.patch";
    sha256 = "1p98j3b1vrryfn1xa7i50m6mmm4dyw5ldafq6kyh9sfmdihz4zsx";
  })];

  cmakeFlags = [
    "-DLLVM_OCAML_OUT_OF_TREE=TRUE"
    "-DLLVM_OCAML_INSTALL_PATH=${placeholder "out"}/ocaml"
    "-DLLVM_OCAML_EXTERNAL_LLVM_LIBDIR=${lib.getLib libllvm}/lib"
  ];

  buildFlags = [ "ocaml_all" ];

  installFlags = [ "-C" "bindings/ocaml" ];

  postInstall = ''
    mkdir -p $OCAMLFIND_DESTDIR/
    mv $out/ocaml $OCAMLFIND_DESTDIR/llvm
    mv $OCAMLFIND_DESTDIR/llvm/META{.llvm,}
  '';

  passthru = {
    inherit libllvm;
  };

  meta = {
    inherit (libllvm.meta) license homepage;
    platforms = ocaml.meta.platforms or [];
    description = "OCaml bindings distributed with LLVM";
    maintainers = with lib.maintainers; [ vbgl ];
  };

}
