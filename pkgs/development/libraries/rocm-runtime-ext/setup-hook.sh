addRocmRuntimeExtDir () {
    if [[ -z "${ROCR_EXT_DIR-}" ]]; then
       export ROCR_EXT_DIR="@out@/lib/rocm-runtime-ext"
    fi
}

addEnvHooks "$hostOffset" addRocmRuntimeExtDir
