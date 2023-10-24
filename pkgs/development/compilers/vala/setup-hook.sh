make_vala_find_vapi_files() {
    # XDG_DATA_DIRS: required for finding .vapi files
    if [ -d "$1/share/vala/vapi" -o -d "$1/share/vala-@apiVersion@/vapi" ]; then
      addToSearchPath XDG_DATA_DIRS $1/share
    fi
}

addEnvHooks "$hostOffset" make_vala_find_vapi_files

disable_incompabile_pointer_conversion_warning() {
    # Work around incompatible function pointer conversion errors with clang 16
    # by setting ``-Wno-incompatible-function-pointer-types` in an env hook.
    # See https://gitlab.gnome.org/GNOME/vala/-/issues/1413.
    NIX_CFLAGS_COMPILE+=" -Wno-incompatible-function-pointer-types"
}

addEnvHooks "$hostOffset" disable_incompabile_pointer_conversion_warning

_multioutMoveVapiDirs() {
  moveToOutput share/vala/vapi "${!outputDev}"
  moveToOutput share/vala-@apiVersion@/vapi "${!outputDev}"
}

preFixupHooks+=(_multioutMoveVapiDirs)
