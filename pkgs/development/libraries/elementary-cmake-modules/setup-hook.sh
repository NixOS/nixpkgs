_elementaryCMakeEnvHook() {
  cmakeFlagsArray+=(-DCMAKE_MODULE_PATH=@out@/lib/cmake)
}
addEnvHooks "$targetOffset" _elementaryCMakeEnvHook
