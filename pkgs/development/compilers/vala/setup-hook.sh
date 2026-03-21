make_vala_find_vapi_files() {
    # XDG_DATA_DIRS: required for finding .vapi files
    if [ -d "$1/share/vala/vapi" -o -d "$1/share/vala-@apiVersion@/vapi" ]; then
      addToSearchPath XDG_DATA_DIRS $1/share
    fi
}

addEnvHooks "$targetOffset" make_vala_find_vapi_files

_multioutMoveVapiDirs() {
  moveToOutput share/vala/vapi "${!outputDev}"
  moveToOutput share/vala-@apiVersion@/vapi "${!outputDev}"
}

preFixupHooks+=(_multioutMoveVapiDirs)
