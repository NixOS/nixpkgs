# shellcheck shell=bash
# Patch all dynamically linked, ELF files with the CUDA driver (libcuda.so)
# coming from the cuda_compat package by adding it to the RUNPATH.
echo "Sourcing auto-add-cuda-compat-runpath-hook"

addCudaCompatRunpath() {
  local libPath
  local origRpath

  if [[ $# -eq 0 ]]; then
    echo "addCudaCompatRunpath: no library path provided" >&2
    exit 1
  elif [[ $# -gt 1 ]]; then
    echo "addCudaCompatRunpath: too many arguments" >&2
    exit 1
  elif [[ "$1" == "" ]]; then
    echo "addCudaCompatRunpath: empty library path" >&2
    exit 1
  else
    libPath="$1"
  fi

  origRpath="$(patchelf --print-rpath "$libPath")"
  patchelf --set-rpath "@libcudaPath@:$origRpath" "$libPath"
}

postFixupHooks+=("autoFixElfFiles addCudaCompatRunpath")
