make_gobject_introspection_find_gir_files() {
    # required for .typelib files, eg mypaint git version
    if [ -d "$1/lib/girepository-1.0" ]; then
      addToSearchPath GI_TYPELIB_PATH $1/lib/girepository-1.0
    fi

    # XDG_DATA_DIRS: required for finding .gir files
    if [ -d "$1/share/gir-1.0" ]; then
      addToSearchPath XDG_DATA_DIRS $1/share
    fi
}

addEnvHooks "$hostOffset" make_gobject_introspection_find_gir_files

giDiscoverSelf() {
    if [ -d "$prefix/lib/girepository-1.0" ]; then
      addToSearchPath GI_TYPELIB_PATH $prefix/lib/girepository-1.0
    fi
}

preFixupHooks+=(giDiscoverSelf)

_multioutMoveGlibGir() {
  moveToOutput share/gir-1.0 "${!outputDev}"
}

preFixupHooks+=(_multioutMoveGlibGir)
