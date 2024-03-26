# shellcheck shell=bash
# Patch all dynamically linked, ELF files with the CUDA driver (libcuda.so)
# coming from the cuda_compat package by adding it to the RUNPATH.

[[ -n ${autoAddCudaCompatRunpath_Once-} ]] && return
declare -g autoAddCudaCompatRunpath_Once=1

echo "Sourcing auto-add-cuda-compat-runpath-hook"

arrayInsertBefore() {
    local -n arrayRef="$1" # Namerefs, bash >= 4.3:
    local pattern="$2"
    local item="$3"
    shift 3

    local i
    local foundMatch=

    local -a newArray
    for i in "${arrayRef[@]}" ; do
        if [[ "$i" == "$pattern" ]] ; then
            newArray+=( "$item" )
            foundMatch=1
        fi
        newArray+=( "$i" )
    done
    if [[ -z "$foundMatch" ]] ; then
        newArray+=( "$item" )
    fi
    arrayRef=( "${newArray[@]}" )
}


if [[ -n "@libcudaPath@" ]] ; then
    arrayInsertBefore elfPrependRunpaths "@driverLink@/lib" "@libcudaPath@"
fi
