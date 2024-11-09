mesonPythonBuildFlagsHook() {
  # Add all of mesonFlags to -Csetup-args for pypa builds
  for f in $mesonFlags; do
    appendToVar pypaBuildFlags "-Csetup-args=$f"
    # This requires pip>23.0.1, see: https://meson-python.readthedocs.io/en/latest/how-to-guides/config-settings.html
    appendToVar pipBuildFlags "--config-settings=setup-args=$f"
  done
}

postConfigureHooks+=(mesonPythonBuildFlagsHook)
