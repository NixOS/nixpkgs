addOcamlMakefile () {
    export OCAMLMAKEFILE="@out@/include/OCamlMakefile"
}

envHooks=(${envHooks[@]} addOcamlMakefile)
