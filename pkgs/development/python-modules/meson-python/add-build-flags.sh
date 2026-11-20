mesonPythonBuildFlagsHook() {
  # Use a build directory with a deterministic path by setting `build-dir` [1]
  # and allow consumers to override it via `mesonBuildDir`.
  # Setting `build-dir` also causes the build directory to be _persistent_,
  # i.e., it won't be deleted after the build [2].
  #
  # [1] https://github.com/mesonbuild/meson-python/issues/671
  # [2] https://mesonbuild.com/meson-python/how-to-guides/config-settings.html#using-a-persistent-build-directory
  #
  : ${mesonBuildDir:=build}
  appendToVar pypaBuildFlags "-Cbuild-dir=$mesonBuildDir"
  appendToVar pipBuildFlags "-Cbuild-dir=$mesonBuildDir"

  # Add all of mesonFlags to `setup-args`
  local flagsArray=()
  concatTo flagsArray mesonFlags mesonFlagsArray
  for f in "${flagsArray[@]}"; do
    appendToVar pypaBuildFlags "-Csetup-args=$f"

    # Using the same config key multiple times requires pip>=23.1, see:
    # https://meson-python.readthedocs.io/en/latest/how-to-guides/config-settings.html
    appendToVar pipBuildFlags "-Csetup-args=$f"
  done
}

postConfigureHooks+=(mesonPythonBuildFlagsHook)
