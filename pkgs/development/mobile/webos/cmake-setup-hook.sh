_addWebOSCMakeFlags() {
  # Help find the webOS cmake module
  cmakeFlagsArray+=(-DCMAKE_MODULE_PATH=@out@/lib/cmake)

  # fix installation path (doesn't use CMAKE_INSTALL_PREFIX)
  cmakeFlagsArray+=(-DWEBOS_INSTALL_ROOT=${!outputBin})
}

preConfigureHooks+=(_addWebOSCMakeFlags)
