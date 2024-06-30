tdeCmakeEnvHook() {
  cmakeFlagsArray+=("-DCMAKE_MODULE_PATH=@out@/lib/cmake/modules;@out@/lib/cmake/templates")
}
addEnvHooks "$targetOffset" tdeCmakeEnvHook
