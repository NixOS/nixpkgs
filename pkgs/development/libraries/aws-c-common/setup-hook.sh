addAwsCCommonModuleDir() {
    cmakeFlags="-DCMAKE_MODULE_PATH=@out@/lib/cmake ${cmakeFlags:-}"
}

postHooks+=(addAwsCCommonModuleDir)
