# shellcheck shell=bash
# Run addDriverRunpath on all dynamically linked ELF files
echo "Sourcing auto-add-driver-runpath-hook"

if [ -z "${dontUseAutoAddDriverRunpath-}" ]; then
  echo "Using autoAddDriverRunpath"
  postFixupHooks+=("autoFixElfFiles addDriverRunpath")
fi
