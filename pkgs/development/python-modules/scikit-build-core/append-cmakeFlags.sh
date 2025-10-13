scikitBuildFlagsHook() {
  OLD_IFS="$IFS"
  IFS=';'

  local args=()
  if [[ -n "$SKBUILD_CMAKE_ARGS" ]]; then
    read -ra existing_args <<< "$SKBUILD_CMAKE_ARGS"
    args+=("${existing_args[@]}")
  fi
  args+=($cmakeFlags)
  args+=("${cmakeFlagsArray[@]}")
  export SKBUILD_CMAKE_ARGS="${args[*]}"

  IFS="$OLD_IFS"
  unset OLD_IFS
}

preConfigureHooks+=(scikitBuildFlagsHook)
