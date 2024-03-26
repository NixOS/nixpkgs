# shellcheck shell=bash
# Equivalent to running addDriverRunpath on all dynamically linked ELF files

[[ -n ${autoAddDriverRunpath_Once-} ]] && return
declare -g autoAddDriverRunpath_Once=1

echo "Sourcing auto-add-driver-runpath-hook.sh"

if [ -z "${dontUseAutoAddDriverRunpath-}" ]; then
  elfPrependRunpaths+=( "@driverLink@/lib" )
fi
