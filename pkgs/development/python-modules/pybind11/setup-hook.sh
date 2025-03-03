# Tell the pybind11 CMake module where to find host platform Python. This is
# required when cross-compiling.
pybind11CMakeFlags () {
  cmakeFlagsArray+=(
    '-DPYBIND11_PYTHONLIBS_OVERWRITE=OFF'
    '-DPYTHON_EXECUTABLE=@pythonInterpreter@'
    '-DPYTHON_INCLUDE_DIR=@pythonIncludeDir@'
    '-DPYTHON_SITE_PACKAGES=@pythonSitePackages@'
  )
}

preConfigureHooks+=(pybind11CMakeFlags)
