{ stdenv, python, llvm, ocaml, findlib, ctypes }:

let version = stdenv.lib.getVersion llvm; in

stdenv.mkDerivation {
  name = "ocaml-llvm-${version}";

  inherit (llvm) src;

  buildInputs = [ python llvm ocaml findlib ctypes ];

  configurePhase = ''
    mkdir build
    cd build
    ../configure CC=gcc CXX=g++ --disable-compiler-version-checks --prefix=$out \
    --disable-doxygen --disable-docs --with-ocaml-libdir=$OCAMLFIND_DESTDIR/llvm \
    --enable-static
    '';

  enableParallelBuilding = false;

  makeFlags = [ "-C bindings" "SYSTEM_LLVM_CONFIG=llvm-config" ];

  postInstall = ''
    mv $OCAMLFIND_DESTDIR/llvm/META{.llvm,}
  '';

  meta = {
    inherit (llvm.meta) license homepage;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    description = "OCaml bindings distributed with LLVM";
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };

}
