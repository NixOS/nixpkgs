scikitBuildFlagsHook() {
  concatTo flagsArray cmakeFlags cmakeFlagsArray

  for arg in "${flagsArray[@]}"; do
    appendToVar pypaBuildFlags "-Ccmake.args=$arg"
  done
}

preConfigureHooks+=(scikitBuildFlagsHook)
