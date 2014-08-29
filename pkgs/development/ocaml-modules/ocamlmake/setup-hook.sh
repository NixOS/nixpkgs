addOcamlMakefile () {
    export OCAMLMAKEFILE="@out@/include/OCamlMakefile"
}

envHooks+=(addOcamlMakefile)
