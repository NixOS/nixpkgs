addIcuDyldPath () {
    addToSearchPath DYLD_LIBRARY_PATH "@icu@/lib"
    export DYLD_LIBRARY_PATH
}

addEnvHooks "$hostOffset" addIcuDyldPath
